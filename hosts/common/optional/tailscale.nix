{ lib, pkgs, ... }:

with lib;

let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
  hasPersistence = builtins.hasAttr "persistence" config.environment;
in
{
  services.tailscale.enable = true;
  networking.firewall = {
    checkReversePath = "loose";
  };

  boot.kernel = mkIf isLinux {
    sysctl."net.ipv4.ip_forward" = 1;
    sysctl."net.ipv6.conf.all.forwarding" = 1;
  };

  environment = lib.mkIf hasPersistence {
    persistence."/persist".directories = [
      "/var/lib/tailscale"
    ];
  };
}
