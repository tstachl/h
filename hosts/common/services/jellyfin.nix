{ ... }:
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  # TODO: add jellyfin to traefik
}
