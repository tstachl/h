{ pkgs, ... }:
{
  programs.git = {
    enable = true;
  };

  environment.defaultPackages = with pkgs; [
    git-annex
  ];
}
