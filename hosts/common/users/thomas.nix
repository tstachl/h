{ pkgs, config, lib, outputs, ... }:
let
  ifExists = groups: builtins.filter (
    group: builtins.hasAttr group.config.users.groups
  ) groups;
in
{
  # TODO: currently only using fish with thomas user
  programs.fish = {
    enable = true;
    vendor = {
      completions.enable = true;
      config.enable = true;
      functions.enable = true;
    };
  };

  users.mutableUsers = false;
  users.users.thomas = {
    isNormalUser = true;
    shell = pkgs.fish;
    
    extraGroups = [ "wheel" "video" "audio" ] ++ ifExists [
      "network" "wireshark" "i2c" "docker" "podman" "git" "libvirtd"
    ];

    openssh.authorizedKeys.keys = [

    ];

    # Password File
    # TODO: would be nice but doesn't work with Salesforce machine.
    # passwordFile = config.sops.secrets.thomas-password.path;
  };

  # services.geoclue2.enable = true;
  # security.pam.services = { swaylock = { }; };
}
