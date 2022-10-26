{
  imports = [
    ./hardware-configuration.nix

    # ../common/global
    # ../common/users/thomas.nix

    # ../common/optional/gnome.nix
    # ../common/optional/nixos.nix
    # ../common/optional/pipewire.nix
    # ../common/optional/tailscale.nix
    # ../common/optional/x11-no-suspend.nix
    # ../common/optional/yubikey.nix
  ];

  networking.hostName = "throwaway";
  time.timeZone = "America/Los_Angeles";
  system.stateVersion = "22.05";
}
