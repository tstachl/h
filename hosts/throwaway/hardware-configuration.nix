{ lib, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ../common/optional/btrfs.nix
    ../common/optional/persistence.nix
    ../common/optional/fuse.nix
    # ../common/optional/encrypted-root.nix
    ../common/optional/systemd-boot.nix
  ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "virtio_pci" "usbhid" "usb_storage" "sr_mod" ];
      kernelModules = [ ];
    };

    kernelModules = [ ];
    extraModulePackages = [ ];
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };
  };

  nixpkgs.hostPlatform.system = "aarch64-linux";
  networking.useDHCP = lib.mkDefault true;
}
