{
  services.caddy = {
    enable = true;
    email = "i@t5.st";

    globalConfig = ''
    tls {
	    dns cloudflare {env.CF_DNS_API_TOKEN}
    }
    '';
  };

  networking.firewall.interfaces.tailscale0 = {
    allowedTCPPorts = [ 80 443 ];
  };
}
