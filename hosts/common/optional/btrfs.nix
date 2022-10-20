{ inputs, lib, config, ... }:
let
  hostname = config.networking.hostName;
  hasPersistence = builtins.hasAttr "persistence" config.environment;

  wipeScript = if hasPersistence then
    ''
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
    '' else "";
in
{
  boot.initrd.postDeviceCommands = lib.mkBefore wipeScript;
  boot.initrd.supportedFilesystems = [ "btrfs" ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/${hostname}";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" "noatime" ];
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
      neededForBoot = true;
    };

    "/swap" = {
      device = "/dev/disk/by-label/${hostname}";
      fsType = "btrfs";
      options = [ "subvol=swap" "noatime" "nodatacow" ];
    };
  };

  swapDevices = [{
    device = "/swap/swapfile";
    size = 4096;
  }];
}
