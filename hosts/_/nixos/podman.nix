{ lib, pkgs, config, ... }:
let
  hasPersistence = builtins.hasAttr "persistence" config.environment;
in
{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
  };

  environment = lib.mkIf hasPersistence {
    persistence."/persist".directories = [
      "/etc/containers"
      "/var/lib/containers"
    ];
  };
}
