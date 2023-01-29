{ pkgs, ... }:
{
  imports = [
    ../default.nix
    ./desktop.nix
    ./home-manager.nix
    ./homebrew.nix
    ./podman.nix
  ];
}
