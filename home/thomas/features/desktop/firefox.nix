{ config, ... }:
{
  programs.firefox = {
    enable = true;

    extensions = with config.nur.repos.rycee.firefox-addons; [
      bitwarden
      # simplelogin
      ublock-origin
      videospeed
      vimium
    ];

    profiles.default = {
      name = "Thomas";
      isDefault = true;

      settings = {
        "browser.startup.homepage" = "https://search.nixos.org";
        "browser.search.region" = "US";
        "browser.search.isUS" = true;
        "distribution.searchplugins.defaultLocale" = "en-US";
        "general.useragent.locale" = "en-US";
      };
    };
  };
}
