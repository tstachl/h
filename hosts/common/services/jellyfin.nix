{ lib, config, ... }:
let
  hasPersistence = builtins.hasAttr "persistence" config.environment;
in
{
  services.jellyfin = {
    enable = true;
  };

  services.caddy.virtualHosts.jellyfin = {
    hostName = "jellyfin.t.t5.st";
    extraConfig = ''
      tls {
        dns cloudflare {env.CF_DNS_API_TOKEN}
      }
      reverse_proxy 127.0.0.1:8096
    '';
  };

  environment = lib.mkIf hasPersistence {
    persistence."/persist".directories = [
      "/var/lib/jellyfin"
    ];
  };
}
