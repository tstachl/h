{ pkgs, ... }:
{
  imports = [
    ./fish.nix
    ./git.nix
    ./gnupg.nix
    ./locale.nix
    ./nix.nix
    ./openssh.nix
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
