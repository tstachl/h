{ config, pkgs, ... }:
{
  # add the host keys
  environment.etc."ssh/ssh_host_rsa_key".source = ./ssh_host_rsa_key;
  environment.etc."ssh/ssh_host_ed25519_key".source = ./ssh_host_ed25519_key;

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

  # configure host keys for throwaway
  services.openssh = {
  };

  # set hostname
  networking.hostName = "throwaway";

  # set timezone
  time.timeZone = "America/Los_Angeles";

  system.stateVersion = "22.05";
}
