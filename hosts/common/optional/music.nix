{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.spotdl
  ];
}
