{ inputs, lib, config, modulesPath, ... }:
{
  imports = [
    # complains about the zfs kernel module
    # (modulesPath + "/installer/sd-card/sd-image-aarch64-new-kernel.nix")
    # breaks on the sun4i-drm module
    ../../modules/nixos/installer/sd-card/sd-image-aarch64-new-kernel.nix
    inputs.hardware.nixosModules.raspberry-pi-4
  ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" ];
    };
    loader.timeout = 5;
  };

  # fileSystems = {
  #   "/boot/firmware" = {
  #     device = "/dev/disk/by-label/FIRMWARE";
  #     fsType = "vfat";
  #     options = [ "nofail" "noauto" ];
  #   };

  #   "/" = {
  #     device = "none";
  #     fsType = "tmpfs";
  #     options = [ "defaults" "size=2G" "mode=755" ];
  #   };

  #   "/boot" = {
  #     device = "/dev/disk/by-label/${config.networking.hostName}";
  #     fsType = "btrfs";
  #     options = [ "subvol=boot" "compress=zstd" "noatime" ];
  #   };

  #   "/nix" = {
  #     device = "/dev/disk/by-label/${config.networking.hostName}";
  #     fsType = "btrfs";
  #     options = [ "subvol=nix" "compress=zstd" "noatime" ];
  #   };

  #   "/persist" = {
  #     device = "/dev/disk/by-label/${config.networking.hostName}";
  #     fsType = "btrfs";
  #     options = [ "subvol=persist" "compress=zstd" "noatime" ];
  #     neededForBoot = true;
  #   };

  #   "/swap" = {
  #     device = "/dev/disk/by-label/${config.networking.hostName}";
  #     fsType = "btrfs";
  #     options = [ "subvol=swap" "noatime" "nodatacow" ];
  #   };
  # };

  # swapDevices = [{
  #   device = "/swap/swapfile";
  #   size = 4096;
  # }];

  sdImage = {
    volumeLabel = "odin";
    compressImage = false;
    imageBaseName = "odin";
  };

  nixpkgs.hostPlatform.system = "aarch64-linux";
  networking.useDHCP = lib.mkDefault true;
  powerManagement.cpuFreqGovernor = "ondemand";
}
