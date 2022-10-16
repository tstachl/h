{ pkgs, ... }:
{
  # allows programs to be run independently from its controlling terminal
  home.packages = [
    pkgs.abduco
  ];
}
