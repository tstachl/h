{ pkgs, lib, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      gnupg
      pinentry
    ];

    # required to use yubikey for SSH
    loginShellInit = lib.mkAfter ''
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    '';
  };
}
