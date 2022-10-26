{ pkgs, ... }:
{
  imports = [
    ./gnupg.nix
    ./locale.nix
    ./nix.nix
    # ./openssh.nix
    # ./podman.nix
  ];

  environment = {
    loginShellInit = ''
      # Activate home-manager environment, if not already
      [ -d "$HOME/.nix-profile" ] || bash -c "$(nix build --no-link --no-write-lock-file --print-out-paths github:tstachl/h#homeConfigurations.$USER@$(hostname).activationPackage)/activate" &> /dev/null
    '';

    # add terminfo files
    enableAllTerminfo = true;

    # add important packages
    systemPackages = with pkgs; [
      git parted
    ];
  };
}
