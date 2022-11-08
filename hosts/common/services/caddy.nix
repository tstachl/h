{
  services.caddy = {
    enable = true;
    email = "i@t5.st";

    globalConfig = ''
      debug
      default_bind thor.taild019.ts.net
    '';
  };

  systemd.services.caddy.serviceConfig.AmbientCapabilities = "CAP_NET_BIND_SERVICE";

  networking.firewall.interfaces.tailscale0 = {
    allowedTCPPorts = [ 80 443 ];
  };
}
