{
  homebrew = {
    casks = [ "brave-browser" "ledger-live" "mouse-fix" "whatsapp" ];
    masApps = {
      "Top Notch" = 1591442999;
      "Tailscale" = 1475387142;
      "Yubico Authenticator" = 1497506650;
    };
    enable = true;
    onActivation.cleanup = "zap";
    onActivation.upgrade = true;
  };
}
