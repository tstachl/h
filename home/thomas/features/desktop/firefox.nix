{ config, ... }:
{
  programs.firefox = {
    enable = true;

    extensions = with config.nur.repos.rycee.firefox-addons; [
      bitwarden
      # simplelogin
      ublock-origin
      videospeed
    ];
  };
}
