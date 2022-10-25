{ inputs, ... }:
{
  imports = [
    ./global.nix
    ./features/desktop
    ./features/nvim
  ];
}
