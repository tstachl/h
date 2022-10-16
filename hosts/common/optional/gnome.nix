{ pkgs, ... }:
{
  services = {
    xserver = {
      enable = true;
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

    udev.packages = with pkgs.gnome;
      [ gnome-settings-daemon ];
    
    # gnome crypto services and tools package
    dbus.packages = [ pkgs.dconf pkgs.gcr ];
    
    avahi.enable = true;
  };

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
