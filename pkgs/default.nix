{ pkgs ? null }:
{
  hparted = pkgs.callPackage ./hparted { };
}
