{
  homebrew = {
    casks = [ "brave-browser" "ledger-live" "mouse-fix" "whatsapp" ];
    masApps = {
      "Tailscale" = 1475387142;
      "Yubico Authenticator" = 1497506650;
    };
    enable = true;
    onActivation.cleanup = "zap";
    onActivation.upgrade = true;
  };
}
