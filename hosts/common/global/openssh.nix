{ outputs, config, lib, ... }:
let
  hosts = builtins.attrNames outputs.nixosConfigurations;
  hasPersistence = builtins.hasAttr "persistence" config.environment;
  prefix = if hasPersistence then "/persist" else "";
in
{
  services.openssh = {
    enable = true;
    # Harden
    passwordAuthentication = false;
    permitRootLogin = "no";
    # Automatically remove stale sockets
    extraConfig = ''
      StreamLocalBindUnlink yes
    '';
    # Allow forwarding ports to everywhere
    # gatewayPorts = "clientspecified";

    hostKeys = [
      {
        bits = 4096;
        path = "${prefix}/etc/ssh/ssh_host_rsa_key";
        type = "rsa";
      }
      {
        path = "${prefix}/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  programs.ssh = {
    # Each hosts public key
    # knownHostsFiles = lib.flatten (map
    #   (host: [
    #     ../../${host}/ssh_host_ed25519_key.pub
    #     ../../${host}/ssh_host_rsa_key.pub
    #   ])
    #   hosts);
  };

  # Passwordless sudo when SSH'ing with keys
  security.pam.enableSSHAgentAuth = true;
}
