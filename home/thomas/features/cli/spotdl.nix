{ pkgs, ... }:
{
  # TODO: need to alias podman version instead.
  programs.fish.shellAliases = {
    spotdl = ''
      ${pkgs.podman}/bin/podman run --rm \
        -v ~/Music:/music \
        spotdl/spotify-downloader \
        --save-file=".spotdl" \
        --format="flac" \
        --output="{artist}/{album} ({year})/{track-number} - {title}" \
    '';
  };
}
