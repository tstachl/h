{ pkgs, ... }:
{
  programs.borgmatic = {
    enable = true;
    backups = {
      thomas = {
        location = {
          sourceDirectories = [ "/persist/home/thomas" ];
          repositories = [ "ssh://sj28ra4j@sj28ra4j.repo.borgbase.com/./repo" ];
        };

        storage.encryptionPasscommand = "${pkgs.rbw}/bin/rbw get thomas-repo";

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
