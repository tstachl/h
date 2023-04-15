{
  homebrew = {
    casks = [
      "brave-browser"
      "keepassxc"
      "ledger-live"
      "mouse-fix"
      "protonvpn"
      "whatsapp"
    ];
    masApps = {
      "Tailscale" = 1475387142;
      "Yubico Authenticator" = 1497506650;
      # "UTM Virtual Machines" = 1538878817; costs $9.99 in the app store
      "Speechify" = 1624912180;
    };
    enable = true;
    onActivation.cleanup = "zap";
    onActivation.upgrade = true;
  };
}
