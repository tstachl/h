{ pkgs, ... }:
{
  services = {
    xserver = {
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
  };

  # Fix broken stuff
  services.avahi.enable = false;
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

  # system tray icons
  services.udev.packages = with pkgs.gnome;
    [ gnome-settings-daemon ];
  
  # gnome crypto services and tools package
  services.dbus.packages = [ pkgs.gcr ];

  # configure keymap in X11
  services.xserver.layout = "us";
}
