{ pkgs, ... }:
{
  imports = [
    ./global.nix
    ./features/desktop/alacritty.nix
    ./features/desktop/fonts.nix
    ./features/nvim
  ];

  home.packages = with pkgs; [
    pkgs.brave
  ];
}
