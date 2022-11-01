{ lib, config, inputs, ... }:
{
  imports = [
    inputs.impermanence.nixosModules.impermanence

    ./hardware-configuration.nix

    ../common/global
    ../common/users/thomas.nix

    ../common/optional/gnome.nix
    ../common/optional/nixos.nix
    ../common/optional/pipewire.nix
    # ../common/optional/tailscale.nix
    ../common/optional/x11-no-suspend.nix
    ../common/optional/yubikey.nix
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
    ];

    users.thomas = {
      directories = [
        "Workspace"
        { directory = ".config/BraveSoftware/"; mode = "0700"; }
      ];

      files = [
        ".ssh/known_hosts"
        ".config/monitors.xml"
        ".config/gh/hosts.yml"
        ".cache/rbw/https%3A%2F%2Fwarden.vault.pilina.com:bw-cli@pilina.email.json"
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

  networking.hostName = "throwaway";
  time.timeZone = "America/Los_Angeles";
  system.stateVersion = "22.11";
}
