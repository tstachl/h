{ config, inputs, lib, modulesPath, ... }:
let
  inherit (config.networking) hostName;
in
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ../common/optional/fuse.nix
    ../common/optional/state.nix
    ../common/optional/systemd-boot.nix
  ];

  boot = {
    initrd = {
      supportedFilesystems = [ "zfs" ];
      availableKernelModules = [ "xhci_pci" "virtio_pci" "usbhid" ];
      kernelModules = [ ];
    };

    kernelModules = [ ];
    extraModulePackages = [ ];
  };

  fileSystems = lib.mkDefault {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "mode=755" ];
    };

    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

    "/nix" = {
      device = "${hostName}/nix";
      fsType = "zfs";
    };

    "/persist" = {
      device = "${hostName}/persist";
      fsType = "zfs";
    };
  };

  nixpkgs.hostPlatform.system = "aarch64-linux";
  networking.useDHCP = lib.mkDefault true;
}
