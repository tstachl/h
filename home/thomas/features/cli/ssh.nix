{ config, ... }:
let
  inherit (config.programs.gpg) homedir;
in
{
  programs.ssh = {
    enable = true;
    compression = true;
    forwardAgent = true;

    matchBlocks = {
      thor = {
        hostname = "thor";
        user = "thomas";
        # remoteForwards = [{
        #   bind.address = "${homedir}/S.gpg-agent.ssh";
        #   host.address = "${homedir}/S.gpg-agent.extra";
        # }];
      };

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
