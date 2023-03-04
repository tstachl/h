{ pkgs, outputs, ... }:
{
  imports = [
    ../default.nix
    ./desktop.nix
    ./home-manager.nix
    ./homebrew.nix
  ] ++ (builtins.attrValues outputs.darwinModules);
}
