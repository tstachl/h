{ config, ... }:
{
  home.sessionVariables = {
    SSH_AUTH_SOCK = "${config.xdg.configHome}/gnupg/S.gpg-agent.ssh";
  };

  programs.ssh = {
    enable = true;
    compression = true;
    forwardAgent = true;

    matchBlocks = {
      vault = {
        hostname = "vault";
        user = "pi";
      };

      "github.com" = {
        user = "git";
      };
    };
  };
}
