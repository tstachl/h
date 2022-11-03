{ inputs, lib, ... }:
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  environment.persistence."/persist" = {
    hideMounts = true;

    directories = [
      "/var/log"
      "/var/lib/systemd/coredump"
    ];

    files = [
      "/etc/machine-id"
    ];
  };
}
