{ inputs, lib, pkgs, config, outputs, ... }:
{
  imports = [
    ./features/cli
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  nixpkgs = {
    config.allowUnfree = true;
    overlays = with outputs.overlays; [ ];
  };

  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" "repl-flakes" ];
      warn-dirty = false;
    };
  };

  home = {
    username = lib.mkDefault "thomas";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "22.05";
  };
}
