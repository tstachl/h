{ pkgs ? null }:
{
  fs-diff = pkgs.callPackage ./fs-diff { };
  hparted = pkgs.callPackage ./hparted { };
}
