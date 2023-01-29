{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    podman
  ];

  homebrew.brews = [ "podman-desktop" ];
}
