{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gnupg
    pinentry
  ];

  services.pcscd.enable = true;
}
