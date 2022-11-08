{
  services.traefik = {
    enable = true;
    dataDir = "/persist/var/lib/traefik";

    staticConfigOptions = {
      api = {
        dashboard = true;
      };

      log = {
        level = "DEBUG";
        filePath = "/var/log/traefik.log";
      };

      entryPoints = {
        http = {
          address = "thor.taild019.ts.net:80";
          http.redirections.entrypoint.to = "https";
          http.redirections.entrypoint.scheme = "https";
        };

        https = {
          address = "thor.taild019.ts.net:443";
          http.tls.certResolver = "letsencrypt";
          http.tls.domains = [
            { main = "t.t5.st"; sans = "*.t.t5.st"; }
          ];
        };
      };

      certificatesResolvers = {
        letsencrypt = {
          acme = {
            email = "i@t5.st";
            storage = "/persist/var/lib/traefik/acme.json";
            dnsChallenge = {
              provider = "cloudflare";
            };
          };
        };
      };
    };

    dynamicConfigOptions = {
      http.routers.traefik.rule = "Host(`t.t5.st`)";
      http.routers.traefik.service = "api@internal";
    };
  };

  networking.firewall.interfaces.tailscale0 = {
    allowedTCPPorts = [ 80 443 ];
  };
  networking.firewall.logRefusedPackets = true;
}
