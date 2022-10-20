{ inputs, config, pkgs, ... }:
let
  inherit (config.sops) secrets;
in
{
  imports = [
    ./hardware-configuration.nix

    ../common/global
    ../common/users/thomas.nix

    ../common/optional/gnome.nix
    ../common/optional/nixos.nix
    ../common/optional/pipewire.nix
    ../common/optional/sops.nix
    # ../common/optional/tailscale.nix
    ../common/optional/x11-no-suspend.nix
    ../common/optional/yubikey.nix
  ];

  sops.defaultSopsFile = ./secrets.yml;
  sops.secrets.thomas.neededForUsers = true;
  users.users.thomas.passwordFile = secrets.thomas.path;

  sops.secrets.github_cli = {
    mode = "0440";
    owner = config.users.users.thomas.name;
    group = config.users.users.thomas.group;
  };

  networking.hostName = "throwaway";
  time.timeZone = "America/Los_Angeles";
  system.stateVersion = "22.05";
}
