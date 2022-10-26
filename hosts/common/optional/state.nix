{ inputs, lib, config, ... }:
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  environment.persistence."/state" = {
    hideMounts = true;

    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
    ];

    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
    ];

    users.thomas = {
      directories = [
        "Workspace"
        { directory = ".config/BraveSoftware/"; mode = "0700"; }
      ];

      files = [
        ".config/monitors.xml"
        ".config/gh/hosts.yml"
      ];
    };
  };

  services.openssh = lib.mkIf config.services.openssh.enable {
    hostKeys = [
      {
        bits = 4096;
        path = "/state/etc/ssh/ssh_host_rsa_key";
        type = "rsa";
      }
      {
        path = "/state/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };
}
