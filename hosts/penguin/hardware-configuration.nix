{ inputs, lib, ... }:
{
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-gpu-intel
    inputs.hardware.nixosModules.common-pc-laptop

    ../common/optional/btrfs.nix
    ../common/optional/persistence.nix
    ../common/optional/fuse.nix
    # ../common/optional/encrypted-root.nix
    ../common/optional/systemd-boot.nix
  ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "dwc3_pci" "usb_storage" "sd_mod" "sr_mod" "sdhci_pci" ];
      kernelModules = [ ];
    };

    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };
  };

  nixpkgs.hostPlatform.system = lib.mkDefault "x86_64-linux";
  networking.useDHCP = lib.mkDefault true;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.video.hidpi.enable = lib.mkDefault true;
  hardware.opengl.enable = lib.mkDefault true;
}
