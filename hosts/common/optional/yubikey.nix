{ pkgs, ... }:
{
  services.udev.packages = with pkgs;
    [ yubikey-personalization ];
  services.pcscd.enable = true;
}
