{ pkgs, ... }:
{
  home.packages = (with pkgs; [
    gnomeExtensions.material-shell
  ]);

  dconf.settings = {
    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = true;
    };
  };
}
