{ inputs, lib, config, ... }:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];
}
