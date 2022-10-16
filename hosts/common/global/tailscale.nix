{
  services.tailscale.enable = true;
  networking.firewall = {
    checkReversePath = "loose";
  };

  # TODO: find a way to auto-logi dn
}
