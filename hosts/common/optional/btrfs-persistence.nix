{ lib, config, pkgs, ... }:
let
  hostname = config.networking.hostName;
  systemdPhase1 = config.boot.initrd.systemd.enable;

  wipeScript = ''
    mkdir -p /mnt
    mount -o subvol=/ /dev/disk/by-label/${hostname} /mnt

    if [ -e "/mnt/root/dontwipe" ]; then
      echo "not wiping root..."
    else
      echo "wiping subvolumes..."
      btrfs subvolume list -o /mnt/root |
        cut -f9 -d ' ' |
        while read subvolume; do
          echo "deleting /$subvolume subvolume..."
          btrfs subvolume delete "/mnt/$subvolume"
        done
      echo "deleting /root subvolume ..."
      btrfs subvolume delete /mnt/root

      echo "restoring blank /root subvolume..."
      btrfs subvolume snapshot /mnt/root-blank /mnt/root
    fi

    umount /mnt
  '';
in
{
  boot.initrd.supportedFilesystems = [ "btrfs" ];

  boot.initrd = {
     systemd = lib.mkIf systemdPhase1 {
       emergencyAccess = true;
       initrdBin = with pkgs; [ coreutils btrfs-progs ];

       services.initrd-btrfs-root-wipe = {
         description = "Wipe ephemeral btrfs root";
         script = wipeScript;
         serviceConfig.Type = "oneshot";
         unitConfig.DefaultDependencies = "no";

         requires = [ "initrd-root-device.target" ];
         before = [ "sysroot.mount" ];
         wantedBy = [ "initrd-root-fs.target" ];
       };
     };

    postDeviceCommands = lib.mkBefore
      (lib.optionalString (!systemdPhase1) wipeScript);
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/${hostname}";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" "noatime" ];
    };

    "/home" = {
      device = "/dev/disk/by-label/${hostname}";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" "noatime" ];
    };

    "/nix" = {
      device = "/dev/disk/by-label/${hostname}";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };

    "/persist" = {
      device = "/dev/disk/by-label/${hostname}";
      fsType = "btrfs";
      options = [ "subvol=persist" "compress=zstd" "noatime" ];
    };

    "/swap" = {
      device = "/dev/disk/by-label/${hostname}";
      fsType = "btrfs";
      options = [ "subvol=swap" "noatime" ];
    };
  };

  swapDevices = [{
    device = "/swap/swapfile";
    size = 4096;
  }];

  # OpenSSH
  services.openssh.hostKeys = lib.mkIf (config.services.openssh.enable) [
    {
      bits = 4096;
      path = "/persist/etc/ssh/ssh_host_rsa_key";
      type = "rsa";
    }
    {
      path = "/persist/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }
  ];

  # Machine Id to fix journalctl logs from past boots
  # https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html
  environment.etc = {
    adjtime.source = "/persist/etc/adjtime";
    machine-id.source = "/persist/etc/machine-id";
  };
}
