{
  homebrew = {
    casks = [ "brave-browser" "ledger-live" "mouse-fix" "whatsapp" ];
    masApps = { "Yubico Authenticator" = 1497506650; };
    enable = true;
    onActivation.cleanup = "zap";
    onActivation.upgrade = true;
  };
}
