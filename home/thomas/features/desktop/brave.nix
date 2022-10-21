{ inputs, ... }:
{
  home.packages = with inputs.brave; [
    legacyPackages.aarch64-linux.brave-nightly
  ];
}
