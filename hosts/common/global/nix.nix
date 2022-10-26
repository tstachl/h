{ pkgs, inputs, lib, config, ... }:
{
  nix = {
    settings = {
      substituters = [
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
      trusted-users = [ "root" "@wheel" ];
      auto-optimise-store = lib.mkDefault true;
    };
    package = pkgs.nixUnstable;
    extraOptions = ''
      auto-optimise-store = true
      experimental-features = nix-command flakes repl-flake
      warn-dirty = false
    '';
    # gc = {
    #   automatic = true;
    #   dates = "weekly";
    #   options = "--delete-older-than 30d";
    # };

    # # Add each flake input as a registry
    # # To make nix3 commands consistent with the flake
    # registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # # Map registries to channels
    # # Very useful when using legacy commands
    # nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
  };
}
