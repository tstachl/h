{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../common/global

    ../common/optional/gnome.nix
    ../common/optional/pipewire.nix
    ../common/optional/systemd-boot.nix
  ];

  # set hostname
  networking.hostName = "throwaway";

  # set timezone
  time.timeZone = "America/Los_Angeles";

  # internationalization properties
  i18n.defaultLocale = "en_US.UTF-8";

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
    git
  ];

  system.stateVersion = "22.05";
}
