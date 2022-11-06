{ pkgs, ... }:
{
  home.packages = with pkgs; [
    spotdl ffmpeg
  ];

  programs.fish.shellAliases = {
    spotdl = "${pkgs.spotdl}/bin/spotdl --ffmpeg \"${pkgs.ffmpeg}/bin/ffmpeg\" --format \"m4a\" --output \"{artist}/{album} ({year})/{track-number} - {title}\"";
  };
}
