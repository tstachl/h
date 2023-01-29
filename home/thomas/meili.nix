{ pkgs, lib, config, ... }:
{
  imports = [
    ./common
    ./features/cli
    ./features/desktop
    ./features/nvim
  ];

  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
  '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';
  manual.manpages.enable = false;
  home.homeDirectory = "/Users/thomas";
}
