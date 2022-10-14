{ pkgs, ... }:
{
  system.activationScripts.decrypt =
    ''
      echo "Current path: $(pwd)"
      # ${pkgs.git-crypt}/bin/git-crypt 
    '';
}
