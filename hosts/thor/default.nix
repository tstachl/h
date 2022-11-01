{
  imports = [
    ./hardware-configuration.nix

    ../common/global
    ../common/optional/state.nix
    ../common/optional/systemd-boot.nix
    ../common/users/thomas.nix

    ../common/optional/nixos.nix
    # ../common/optional/tailscale.nix
  ];

  networking.hostId = "575e22bc";
  networking.hostName = "thor";
  time.timeZone = "America/Santiago";
  system.stateVersion = "22.11";
}
