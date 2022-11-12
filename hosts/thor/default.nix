{ lib, config, inputs, ... }:
let
  defaultMount = {
    bucket = "thordata";
    automount = true;
    passwd_file = config.age.secrets.wasabi-tokens.path;
    url = "https://s3.wasabisys.com";
  };
in
{
  imports = [
    ./hardware-configuration.nix

    ../common/global
    ../common/optional/systemd-boot.nix
    ../common/users/thomas.nix

    ../common/optional/tailscale.nix

    ../common/services/jellyfin.nix
    ../common/services/caddy.nix
  ];

  # Caddy Service Secret
  age.secrets.cloudflare-token = {
    file = ../../keys/cloudflare-token.age;
    mode = "660";
    owner = "caddy";
    group = "caddy";
  };
  systemd.services.caddy.serviceConfig.EnvironmentFile = [
    config.age.secrets.cloudflare-token.path
  ];

  # s3fs Service Secret
  age.secrets.wasabi-tokens.file = ../../keys/wasabi-tokens.age;

  services.s3fs = {
    enable = true;
    mounts = {
      "/mnt/music" = defaultMount // { path = "/music"; };
      "/mnt/books" = defaultMount // { path = "/books"; };
    };
  };

  networking.firewall.interfaces.tailscale0.allowedTCPPortRanges = [
    { from = 0; to = 65535; }
  ];

  networking.hostId = "575e22bc";
  networking.hostName = "thor";
  time.timeZone = "America/Santiago";
  system.stateVersion = "22.11";
}
