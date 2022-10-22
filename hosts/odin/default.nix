{ config, ... }:
let
  inherit (config.sops) secrets;
in
{
  imports = [
    ./hardware-configuration.nix

    ../common/global
    ../common/users/pi.nix

    ../common/optional/nixos.nix
    ../common/optional/sops.nix
    # ../common/optional/tailscale.nix
  ];

  sops.defaultSopsFile = ./secrets.yml;
  sops.secrets.pi.neededForUsers = true;
  users.users.pi.passwordFile = secrets.pi.path;

  networking.hostName = "odin";
  time.timeZone = "Europe/Vienna";
  system.stateVersion = "22.05";
}
