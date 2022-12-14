{ pkgs, ... }:
{
  programs.dconf.enable = true;

  services = {
    xserver = {
      enable = true;
      layout = "us";

      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
    };

    # geoclue2.enable = true;
    gnome.games.enable = false;
  };

  # Remove bloat from Gnome
  environment.gnome.excludePackages = (with pkgs; [
    # gnome-console
    gnome-photos
    gnome-text-editor
    gnome-tour
    gnome-user-docs
    xterm
  ]) ++ (with pkgs.gnome; [
    cheese # webcam tool
    gnome-music
    gnome-contacts
    gnome-calendar
    gnome-terminal
    gnome-maps
    gnome-weather
    gedit
    simple-scan # document scanner
    yelp # the help viewer in Gnome
    epiphany # web browser
    geary # email client
    eog # image viewer
    evince # document viewer
    gnome-characters
    totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
  ]);
}
