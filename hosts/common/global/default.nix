{ lib, inputs, ... }:
{
  imports = [
    ./fish.nix
    ./gpg.nix
    ./locale.nix
    ./nix.nix
    ./podman.nix
  ];

  environment = {
    loginShellInit = ''
      # Activate home-manager environment, if not already
      [ -d "$HOME/.nix-profile" ] || /nix/var/nix/profiles/per-user/$USER/home-manager/activate &> /dev/null
    '';

    # add terminfo files
    enableAllTerminfo = true;
  };
}
