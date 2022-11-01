{ lib, config, inputs, ... }:
{
  imports = [
    inputs.impermanence.nixosModules.impermanence

    ./hardware-configuration.nix

    ../common/global
    ../common/optional/systemd-boot.nix
    ../common/users/thomas.nix

    ../common/optional/nixos.nix
    ../common/optional/tailscale.nix
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

    users.thomas = {
      directories = [
        "Workspace"
      ];

      files = [
        ".ssh/known_hosts"
        ".config/gh/hosts.yml"
      ];
    };
  };

  services.openssh = lib.mkIf config.services.openssh.enable {
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

  networking.hostId = "575e22bc";
  networking.hostName = "thor";
  time.timeZone = "America/Santiago";
  system.stateVersion = "22.11";
}
