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
      options = [ "subvol=n" "compress=zstd" "noatime" ];
    };

    "/persist" = {
      device = "/dev/disk/by-label/${hostName}";
      fsType = "btrfs";
      options = [ "subvol=p" "compress=zstd" "noatime" ];
      neededForBoot = true;
    };

    "/swap" = {
      device = "/dev/disk/by-label/${hostName}";
      fsType = "btrfs";
      options = [ "subvol=s" "noatime" "nodatacow" ];
    };
  };

  swapDevices = [{
    device = "/swap/swapfile";
    size = 4096;
  }];
}
