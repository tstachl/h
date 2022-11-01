{ pkgs, ... }:
{
  programs.borgmatic = {
    enable = true;
    backups = {
      thomas = {
        location = {
          sourceDirectories = [ "/persist" ];
          repositories = [ "ssh://o193c84l@o193c84l.repo.borgbase.com/./repo" ];
        };

        storage.encryptionPasscommand = "${pkgs.pass}/bin/pass technology/borg";

        retention = {
          keepDaily = 7;
          keepWeekly = 4;
          keepMonthly = 6;
        };

        consistency = {
          checks = [
            { name = "repository"; frequency = "2 weeks"; }
            { name = "archives"; frequency = "2 weeks"; }
          ];
        };
      };
    };
  };
}
