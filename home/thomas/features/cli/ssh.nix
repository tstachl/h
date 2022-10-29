{ config, ... }:
{
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
