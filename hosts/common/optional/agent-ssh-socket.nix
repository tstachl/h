{ lib, config, ... }:
let
  gpgPkg = config.programs.gnupg.package;
in
{
  environment.loginShellInit = lib.mkAfter ''
    export SSH_AUTH_SOCK="$(${gpgPkg}/bin/gpgconf --list-dirs agent-ssh-socket)";
  '';
}
