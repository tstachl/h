{ lib, config, pkgs, ... }:
let
  hostname = config.networking.hostName;
  systemdPhase1 = config.boot.initrd.systemd.enable;

  wipeScript = ''
    mount -o subvol=/ /dev/disk/by-label/${hostname} /mnt

    if [ -e "/mnt/root/dontwipe" ]; then
      echo "Not wiping root"
    else
      echo "Cleaning subvolume"
      btrfs subvolume list -o /root | cut -f9 -d ' ' |
      while read subvolume; do
        btrfs subvolume delete "/mnt/$subvolume"
      done && btrfs subvolume delete /mnt/root

      echo "Restoring blank subvolume"
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
      initrdBin = with pkgs; [ coreutils btrfs-props ];

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
}
