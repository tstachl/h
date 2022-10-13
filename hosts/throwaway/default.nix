{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../common/global

    ../common/optional/gnome.nix
    ../common/optional/pipewire.nix
    ../common/optional/systemd-boot.nix
    ../common/optional/x11-no-suspend.nix
    ../common/optional/yubikey.nix
  ];

  # set hostname
  networking.hostName = "throwaway";

  # set timezone
  time.timeZone = "America/Los_Angeles";

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
