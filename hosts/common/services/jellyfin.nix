{ ... }:
{
  services.jellyfin = {
    enable = true;
  };

  # TODO: add jellyfin to traefik
  services.traefik.dynamicConfigOptions = {
    http.routers.jellyfin.rule = "Host(`jellyfin.t.t5.st`)";
    http.routers.jellyfin.service = "jellyfin@file";
    http.routers.jellyfin.middlewares = "jellyfin";
    http.middlewares.jellyfin.headers.customResponseHeaders.X-Robots-Tag = "noindex,nofollow,nosnippet,noarchive,notranslate,noimageindex";
    http.middlewares.jellyfin.headers.SSLRedirect = true;
    http.middlewares.jellyfin.headers.SSLHost = "jellyfin.t.t5.st";
    http.middlewares.jellyfin.headers.SSLForceHost = true;
    http.middlewares.jellyfin.headers.STSSeconds = 315360000;
    http.middlewares.jellyfin.headers.STSIncludeSubdomains = true;
    http.middlewares.jellyfin.headers.STSPreload = true;
    http.middlewares.jellyfin.headers.forceSTSHeader = true;
    http.middlewares.jellyfin.headers.frameDeny = true;
    http.middlewares.jellyfin.headers.contentTypeNosniff = true;
    http.middlewares.jellyfin.headers.browserXSSFilter = true;
    http.middlewares.jellyfin.headers.customFrameOptionsValue = "'allow-from https://jellyfin.t.t5.st'";
    http.services.jellyfin.loadbalancer.servers.url = "http://thor:8096";
  };
}
