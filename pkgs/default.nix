{ pkgs ? null }:
{
  fs-diff = pkgs.callPackage ./fs-diff { };
  hparted = pkgs.callPackage ./hparted { };
  mycaddy = pkgs.callPackage ./mycaddy.nix {
    plugins = [ "github.com/caddy-dns/cloudflare" ];
    sha256 = "sha256-i5T6i1aiZ8XTZIQ6vHuOwvv/jdt4XdB+COROeWfNiIY=";
  };
}
