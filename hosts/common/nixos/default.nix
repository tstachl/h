{ pkgs, outputs, ... }:
{
  imports = [
    ../default.nix
    ./agenix.nix
    ./home-manager.nix
    ./locale.nix
    ./openssh.nix
    ./persist.nix
    ./podman.nix
    ./tailscale.nix
  ] ++ (builtins.attrValues outputs.nixosModules);

  nix.gc.dates = "weekly";

  environment = {
    # add terminfo files
    enableAllTerminfo = true;

    # add important packages
    systemPackages = with pkgs; [
      parted
    ];
  };
}
