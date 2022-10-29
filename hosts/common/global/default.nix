{ pkgs, ... }:
{
  imports = [
    ./gnupg.nix
    ./home-manager.nix
    ./locale.nix
    ./nix.nix
    ./openssh.nix
    ./podman.nix
  ];

  environment = {
    # add terminfo files
    enableAllTerminfo = true;

    # add important packages
    systemPackages = with pkgs; [
      git parted
    ];
  };
}
