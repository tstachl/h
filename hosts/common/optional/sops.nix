{ inputs, ... }:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops.age.sshKeyPaths = [
    "/persist/etc/ssh/ssh_host_ed25519_key"
    "/persist/etc/ssh/ssh_host_rsa_key"
  ];
}
