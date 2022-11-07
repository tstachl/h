{ lib, config, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../common/global
    ../common/optional/systemd-boot.nix
    ../common/users/thomas.nix

    ../common/optional/nixos.nix
    ../common/optional/tailscale.nix

    ../common/services/jellyfin.nix
  ];

  networking.hostId = "575e22bc";
  networking.hostName = "thor";
  time.timeZone = "America/Santiago";
  system.stateVersion = "22.11";
}
