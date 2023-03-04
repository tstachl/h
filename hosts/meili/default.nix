{ pkgs, ... }:
{
  imports = [
    ../common/darwin
  ];

  services.nix-daemon.enable = true;
  programs.nix-index.enable = true;

  system.keyboard.enableKeyMapping = true;

  system.keyboard.userKeyMapping = [{
    HIDKeyboardModifierMappingSrc = 30064771129;
    HIDKeyboardModifierMappingDst = 30064771298;
  }];

  system.defaults = {
    dock = {
      autohide = true;
      orientation = "bottom";
    };

    finder = {
      AppleShowAllExtensions = true;
      _FXShowPosixPathInTitle = true;
      FXEnableExtensionChangeWarning = false;
    };

    NSGlobalDomain = {
     _HIHideMenuBar = true;
     "com.apple.swipescrolldirection" = false;
    };

    screencapture.location = "/tmp";

    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
    };
  };

  # Add ability to used TouchID for sudo authentication
  # Also not allowed on work computer?
  security.pam.enableSudoTouchIdAuth = true;

  users.users.thomas = {
    shell = pkgs.fish;
    home = "/Users/thomas";
  };

  home-manager.users.thomas = import ../../home/thomas/meili.nix;

  networking.hostName = "meili";
  networking.remoteLogin = true;
  time.timeZone = "America/Lima";
  system.stateVersion = 4;
}
