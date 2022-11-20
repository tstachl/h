{ pkgs, ... }:
{
  imports = [
    ./agenix.nix
    ./fish.nix
    ./git.nix
    ./gnupg.nix
    ./home-manager.nix
    ./locale.nix
    ./nix.nix
    ./openssh.nix
    ./persist.nix
    ./podman.nix
    ./spotdl.nix
  ];

  environment = {
    # add terminfo files
    enableAllTerminfo = true;

    # add important packages
    systemPackages = with pkgs; [
      ripgrep jq parted
    ];
  };
}
