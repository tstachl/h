{ lib, config, inputs, ... }:
let
  hasPersistence = builtins.hasAttr "persistence" config.environment;
in
{
  imports = [
    ../common/global
    ../common/global/darwin

    ../common/users/thomas.nix

    ../common/optional/agent-ssh-socket.nix
    ../common/optional/tailscale.nix
    ../common/optional/yubikey.nix
  ];

  environment = lib.mkIf hasPersistence {
    persistence."/persist".directories = [
      "/etc/NetworkManager/system-connections"
      "/var/lib/bluetooth"
      "/var/lib/yubico"
    ];
  };

  networking.hostName = "meili";
  time.timeZone = "America/Los_Angeles";
  system.stateVersion = "22.11";
}
