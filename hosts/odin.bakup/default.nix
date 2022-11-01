{
  imports = [
    ./hardware-configuration.nix

    ../common/global
    ../common/users/thomas.nix

    ../common/optional/nixos.nix
    # ../common/optional/tailscale.nix
  ];

  networking.hostName = "odin";
  time.timeZone = "Europe/Vienna";
  system.stateVersion = "22.11";
}
