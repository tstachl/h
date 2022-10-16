{ pkgs, ... }:
{
  # dynamic virtual terminal manager
  home.packages = [
    pkgs.dvtm
  ];
}
