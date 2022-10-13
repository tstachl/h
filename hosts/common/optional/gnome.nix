{ pkgs, ... }:
{
  services = {
    xserver = {
      enable = true;

      # configure keymap in X11
      layout = "us";

      desktopManager.gnome = {
        enable = true;
      };

      displayManager.gdm = {
        enable = true;
        autoSuspend = false;
      };
    };

    geoclue2.enable = true;
    gnome.games.enable = false;

    # system tray icons
    udev.packages = with pkgs.gnome;
      [ gnome-settings-daemon ];
    
    # gnome crypto services and tools package
    dbus.packages = [ pkgs.gnome.dconf pkgs.gcr ];
    
    avahi.enable = false;
  };

  # Fix broken stuff
  networking.networkmanager.enable = false;

  # Remove bloat from Gnome
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    cheese # webcam tool
    gnome-music
    gnome-terminal
    gedit
    epiphany # web browser
    geary # email client
    evince # document viewer
    gnome-characters
    totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
  ]);
}
