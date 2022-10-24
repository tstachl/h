{ inputs, lib, modulesPath, ... }:
{
  imports = [
    ../../modules/nixos/sd-image.nix
    inputs.hardware.nixosModules.raspberry-pi-4
  ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" ];
    };
    loader.timeout = 5;
  };

  sdImage = {
    compressImage = false;
    imageBaseName = "odin";
  };

  nixpkgs.hostPlatform.system = "aarch64-linux";
  networking.useDHCP = lib.mkDefault true;
  powerManagement.cpuFreqGovernor = "ondemand";
}
