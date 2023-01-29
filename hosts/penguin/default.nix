{ lib, config, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../common/nixos
    ../common/users/thomas.nix

    ../common/nixos/gnome.nix
    ../common/nixos/pipewire.nix
    ../common/nixos/x11-no-suspend.nix
    ../common/nixos/yubikey.nix
  ];

  environment.persistence."/persist" = {
    directories = [
      "/etc/NetworkManager/system-connections"
      "/var/lib/bluetooth"
      "/var/lib/yubico"
    ];
  };

  networking.hostId = "24f7ca5f";
  networking.hostName = "penguin";
  time.timeZone = "America/Los_Angeles";
  system.stateVersion = "22.11";
}
