{ pkgs, ... }:
{
  home.packages = [
    pkgs.spotdl
  ];

  programs.fish.shellAliases = {
    spotdl = "${pkgs.spotdl}/bin/spotdl --output-format m4a --path-template \"{artist}/{album} ({year})/{track-number} - {title}.{ext}\"";
  };
}
