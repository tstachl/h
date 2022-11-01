{
  imports = [
    ./hardware-configuration.nix

    ../common/global
    ../common/users/thomas.nix

    ../common/optional/nixos.nix
    # ../common/optional/tailscale.nix
  ];

  networking.hostId = "e4498598";
  networking.hostName = "odin";
  time.timeZone = "America/Santiago";
  system.stateVersion = "22.11";
}
