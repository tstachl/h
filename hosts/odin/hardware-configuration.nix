{ inputs, config, lib, pkgs, ... }:
{
  imports = [
    inputs.hardware.nixosModules.raspberry-pi-4
    # ../common/optional/btrfs-persistence.nix
    # ../common/optional/encrypted-root.nix
    ../common/optional/systemd-boot.nix
  ];

# builtins.hasAttr "persistence" outputs.nixosConfigurations.throwaway.ctrueg.environment

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" ];
    };
    loader.timeout = 5;
  };



  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "ext4";
      neededForBoot = true;
    };

    "/firmware" = {
      device = "/dev/disk/by-label/FIRMWARE";
      fsType = "vfat";
    };
  };

  nixpkgs.hostPlatform.system = "aarch64-linux";
  networking.useDHCP = lib.mkDefault true;
}
