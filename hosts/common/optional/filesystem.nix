{ inputs, lib, config, ... }:
let
  inherit (config.networking) hostName;
in
{
  boot.initrd.supportedFilesystems = [ "btrfs" ];

  fileSystems = {
    "/nix" = {
      device = "/dev/disk/by-label/${hostName}";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };

    "/state" = {
      device = "/dev/disk/by-label/${hostName}";
      fsType = "btrfs";
      options = [ "subvol=persist" "compress=zstd" "noatime" ];
      neededForBoot = true;
    };

    "/swap" = {
      device = "/dev/disk/by-label/${hostName}";
      fsType = "btrfs";
      options = [ "subvol=swap" "noatime" "nodatacow" ];
    };
  };

  swapDevices = [{
    device = "/swap/swapfile";
    size = 4096;
  }];
}
