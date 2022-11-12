{ inputs, lib, config, ... }:
let
  inherit (config.networking) hostName;
in
{
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-gpu-intel
    inputs.hardware.nixosModules.common-pc-laptop

    ../common/optional/systemd-boot.nix
    ../common/optional/fuse.nix
  ];

  boot = {
    initrd = {
      supportedFilesystems = [ "zfs" ];
      availableKernelModules = [ "xhci_pci" "dwc3_pci" "usb_storage" "sd_mod" "sr_mod" "sdhci_pci" ];
      kernelModules = [ ];
    };

    kernelModules = [ "kvm-intel" ];
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

  nixpkgs.hostPlatform.system = "x86_64-linux";
  networking.useDHCP = lib.mkDefault true;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.video.hidpi.enable = lib.mkDefault true;
  hardware.opengl.enable = lib.mkDefault true;
}
