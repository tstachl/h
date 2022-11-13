{ outputs, config, lib, pkgs, ... }:
let
  hosts = builtins.attrNames outputs.nixosConfigurations;
in
{
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
    extraConfig = ''
      StreamLocalBindUnlink yes
    '';

    hostKeys = [
      {
        bits = 4096;
        path = "/persist/etc/ssh/ssh_host_rsa_key";
        type = "rsa";
      }
      {
        path = "/persist/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  programs.ssh.knownHostsFiles = [
    ../../../keys/github.keys
    ../../../keys/thor.keys
    ../../../keys/penguin.keys
    ../../../keys/vault.keys
  ];

  # Passwordless sudo when SSH'ing with keys
  security.pam.enableSSHAgentAuth = true;
}
