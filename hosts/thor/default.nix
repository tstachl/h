{ lib, config, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../common/global
    ../common/optional/systemd-boot.nix
    ../common/users/thomas.nix

    ../common/optional/tailscale.nix

    #../common/services/traefik.nix
    #../common/services/jellyfin.nix
    ../common/services/caddy.nix
  ];

  age.secrets.cloudflare_token = {
    file = ../../keys/cloudflare_token.age;
    mode = "660";
    owner = "traefik";
    group = "traefik";
  };
  systemd.services.caddy.serviceConfig.EnvironmentFile = [
    config.age.secrets.cloudflare_token.path
  ];

  networking.hostId = "575e22bc";
  networking.hostName = "thor";
  time.timeZone = "America/Santiago";
  system.stateVersion = "22.11";
}
