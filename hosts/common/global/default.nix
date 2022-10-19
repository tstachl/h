{ lib, inputs, ... }:
{
  imports = [
    ./gnupg.nix
    ./locale.nix
    ./nix.nix
    ./openssh.nix
    ./podman.nix
    ./ripgrep.nix
    ./tailscale.nix
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
