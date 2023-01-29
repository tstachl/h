{ ... }:
{
  imports = [
    ../_/darwin
    # ../common/global
    # ../common/global/darwin

    # ../common/users/thomas.nix

    # ../common/optional/agent-ssh-socket.nix
    # ../common/optional/tailscale.nix
    # ../common/optional/yubikey.nix
  ];

  # networking.hostName = "meili";
  # time.timeZone = "America/Los_Angeles";
  # system.stateVersion = "22.11";
}
