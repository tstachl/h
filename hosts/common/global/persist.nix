{ inputs, lib, ... }:
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  environment.persistence."/persist" = {
    hideMounts = true;

    directories = [
      "/var/lib/systemd/coredump"
      "/var/log"
    ];

    files = [
      "/etc/machine-id"
    ];
  };
}
