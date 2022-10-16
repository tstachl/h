{ config, lib, pkgs, ... }:

with lib;

let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
  inherit (config.xdg) configHome;
in
{
  home.sessionVariables = {
    GNUPGHOME = "${configHome}/gnupg";
  };

  programs.gpg = {
    enable = true;
    homedir = "${configHome}/gnupg";

    publicKeys = [{
      source = ./7A53D4C6B481F7711588D34FDE749C31D060A160.asc;
      trust = 5;
    }];

    settings = {
      no-comments = true;
      no-emit-version = true;
      no-symkey-cache = true;
      default-new-key-algo = "ed25519/cert,sign+cv25519/encr";
      personal-cipher-preferences = "AES256 CAMELLIA256 AES192 CAMELLIA192 AES CAMELLIA128";
      personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
      personal-digest-preferences = "SHA512 SHA384 SHA256";
      pinentry-mode = "loopback";
    };

    scdaemonSettings = {
      reader-port = "Yubico Yubi";
      disable-ccid = true;
    };
  };

  services.gpg-agent = mkIf isLinux {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableSshSupport = true;
    pinentryFlavor = "curses";
    sshKeys = [
      "0C8022799396573FE31D595B2C4B60B871618D9C"
    ];
  };
}
