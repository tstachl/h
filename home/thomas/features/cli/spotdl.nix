{ lib, pkgs, ... }:
{
  programs.fish = {
    # TODO: check if certain named arguments are set and default if not
    interactiveShellInit = lib.mkAfter ''
      function spotdl -d "Run spotdl in the current directory with my defaults"
        ${pkgs.podman}/bin/podman run --rm \
          -v $(pwd):/music \
          spotdl/spotify-downloader \
          --save-file=".spotdl" \
          --format="flac" \
          --output="{artist}/{album} ({year})/{track-number} - {title}" \
      end
    '';
  };
}
