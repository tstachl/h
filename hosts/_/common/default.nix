{ pkgs, ... }:
{
  imports = [
    ./fish.nix
    ./git.nix
    ./gnupg.nix
    ./nix.nix
    ./spotdl.nix
    ./tailscale.nix
  ];

  environment.systemPackages = with pkgs; [
    ripgrep jq
  ];
}
