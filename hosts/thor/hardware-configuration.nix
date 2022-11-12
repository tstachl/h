{ config, inputs, lib, modulesPath, ... }:
let
  inherit (config.networking) hostName;
in
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ../common/optional/fuse.nix
  ];

  boot = {
    initrd = {
      supportedFilesystems = [ "zfs" ];
      availableKernelModules = [ "xhci_pci" "virtio_pci" "usbhid" ];
      kernelModules = [ ];
    };

    kernelModules = [ ];
    extraModulePackages = [ ];

    zfs = {
      devNodes = "/dev/disk/by-path";
    };
  };

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = [ "defaults" "mode=755" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  fileSystems."/nix" = {
    device = "${hostName}/nix";
    fsType = "zfs";
  };

  fileSystems."/persist" = {
    device = "${hostName}/persist";
    fsType = "zfs";
    neededForBoot = true;
  };

  nixpkgs.hostPlatform.system = "aarch64-linux";
  networking.useDHCP = lib.mkDefault true;
}
