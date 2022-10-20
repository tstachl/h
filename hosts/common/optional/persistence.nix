{ inputs, ... }:
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  environment.persistence."/persist" = {
    hideMounts = true;

    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
    ];

    files = [
      "/etc/machine-id"

      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
  };
}
