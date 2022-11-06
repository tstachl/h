{ inputs, lib, pkgs, config, outputs, ... }:
{
  imports = [
    inputs.nur.hmModules.nur
    ./nix.nix
    ../features/cli
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  xdg.enable = true;
  programs.home-manager.enable = true;
  programs.bash.enable = true;

  home = {
    username = lib.mkDefault "thomas";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "22.11";
  };
}
