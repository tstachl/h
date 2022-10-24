{ inputs, config, lib, pkgs, modulesPath, ... }:
{
  imports = [
    "${modulesPath}/installer/sd-card/sd-image-aarch64-new-kernel.nix"
    inputs.hardware.nixosModules.raspberry-pi-4
  ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" ];
    };
    loader.timeout = 5;
  };

  sdImage.imageBaseName = "odin";

  nixpkgs.hostPlatform.system = "aarch64-linux";
  networking.useDHCP = lib.mkDefault true;
  powerManagement.cpuFreqGovernor = "ondemand";
}
