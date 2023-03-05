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
    # openssh.authorizedKeys.keys = [
    #   "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC5o7LT5wPYWgI8Mvr6RKOv+BcsbQgU7PCw2hheVu17alwF1uFUsAYV5BVQu+uv9uEm/UDsCNhfM6TwI0A1prdmtBz4pKiwXbj7fcdp6DcVOgTsPfawbXEpivtJvlhEatyTsR26MjHKnqpT0BxPvj6Ug6pvRkCYW5d2bWXiY9murmAX6Q5kSyNunkB8PdRTH+S47f7eOdCJY63VBOkkiG8M7XyPwFCDTYiHhbMZcejIdY9mB6kYnMQVRHDznQWiQxrcaE1fD/TY3db9GDcOVoo2aDBOZX7WT2+me67sU8dEK9+nSyhWDzBbEs8knu87ZlKPFwhl4slenRniKhbf22OpicXArtEcjEj0GyDJH5e+ZCIQ4eSQanA7TxnKFlDuaf+Qqx55UT+ya4vJJeik7nkzbRHaE9IoWhhiOaOnaN6kHIxuxB6z7EL3Gk7f78+I/qBaj5df6fgnXM3JBXKa5bRH2wqoSetJAo6EGpEgmU2huB1ktiGlO7BlF5XwSw6cb/KT7NSIXhncgLkCzsDVXxecVQv1FnPISBcp3+ti01ADVf2trgpPDbNTWV40Rgiefie0o2fc6KWAFfum1j5N3WWU+XVVmRjDmKKHiEJBLNKDAe0rQf+tryPW4c5GIN7aFoB+8dYFAuUyLd7Fu3vhZdmcckN5ryHunEc0dKPIiuoVZw=="
    # ];
  };

  home-manager.users.thomas = import ../../home/thomas/meili.nix;

  networking.hostName = "meili";
  networking.remoteLogin = true;
  time.timeZone = "America/Lima";
  system.stateVersion = 4;
}
