{ pkgs, ... }:
{
  services.udev.packages = with pkgs;
    [ yubikey-personalization ] ++ services.udev.packages;
}
