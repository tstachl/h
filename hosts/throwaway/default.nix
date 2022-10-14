{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../common/global
    ../common/users/thomas.nix

    ../common/optional/gnome.nix
    ../common/optional/nixos.nix
    ../common/optional/pipewire.nix
    ../common/optional/sops.nix
    ../common/optional/systemd-boot.nix
    ../common/optional/x11-no-suspend.nix
    ../common/optional/yubikey.nix
  ];

  # set the correct path to the sops file
  sops.defaultSopsFile = ../common/secrets.yaml;

  # configure host keys for throwaway
  services.openssh = {
    hostKeys = [
      {
        bits = 4096;
        path = config.sops.secrets.hosts_throwaway_ssh_key_rsa.path;
        type = "rsa";
      }
      {
        path = config.sops.secrets.hosts_throwaway_ssh_key_ed25519.path;
        type = "ed25519";
      }
    ];
  };

  # set hostname
  networking.hostName = "throwaway";

  # set timezone
  time.timeZone = "America/Los_Angeles";

  system.stateVersion = "22.05";
}
