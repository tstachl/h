{ lib, config, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../common/global
    ../common/users/thomas.nix

    ../common/optional/agent-ssh-socket.nix
    ../common/optional/gnome.nix
    ../common/optional/pipewire.nix
    ../common/optional/tailscale.nix
    ../common/optional/x11-no-suspend.nix
    # ../common/optional/xserver.nix
    ../common/optional/yubikey.nix
  ];

  networking.hostId = "24f7ca5f";
  networking.hostName = "penguin";
  time.timeZone = "America/Los_Angeles";
  system.stateVersion = "22.11";
}
