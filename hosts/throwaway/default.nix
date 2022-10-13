{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../common/global

    ../common/optional/gnome.nix
    ../common/optional/pipewire.nix
  ];

  # use the systemd-boot EFI boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # set hostname
  networking.hostName = "throwaway";

  # set timezone
  time.timeZone = "America/Los_Angeles";

  # internationalization properties
  i18n.defaultLocale = "en_US.UTF-8";

  # enable sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # user account
  users.users.thomas = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      firefox
    ];
  };

  # system packages
  environment.systemPackages = with pkgs; [
    neovim
    git
    gnupg
  ];

  system.stateVersion = "22.05";
}
