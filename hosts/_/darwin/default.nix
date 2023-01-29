{ pkgs, ... }:
{
  imports = [
    ../common
    ./desktop.nix
    ./home-manager.nix
    ./homebrew.nix
    ./podman.nix
  ];

  environment.gnome.enable = true;
}
