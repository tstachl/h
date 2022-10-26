{ inputs }:
{
  imports = [
    ./global.nix
    ./features/desktop/alacritty.nix
    ./features/desktop/fonts.nix
    ./features
    # ./features/desktop
    ./features/nvim
  ];

  home.packages = with pkgs; [
    pkgs.brave
  ];
}
