{ lib, ... }:
{
  programs.fish.interactiveShellInit = lib.mkAfter ''
    set -gx GH_TOKEN "$(cat /run/secrets/github_cli)"
  '';

  programs.gh = {
    enable = true;
  };
}
