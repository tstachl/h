{ inputs, lib, pkgs, config, outputs, ... }:
{
  imports = [
    inputs.nur.hmModules.nur
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
      warn-dirty = false;
    };
  };

  xdg.enable = true;
  programs.home-manager.enable = true;
  programs.bash.enable = true;

  home = {
    username = lib.mkDefault "thomas";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "22.11";
  };
}
