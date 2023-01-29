{ pkgs, ... }:
{
  services.udev.packages = with pkgs;
    [ yubikey-personalization ];
  services.pcscd.enable = true;

  # Require yubikey to login
  security.pam.yubico = {
    enable = true;
    control = "required";
    mode = "challenge-response";
    challengeResponsePath = "/var/lib/yubico";
  };
}
