{ pkgs, ... }:
{
  home.packages = with pkgs; [ cozy ];
}
