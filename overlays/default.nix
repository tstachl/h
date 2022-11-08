{
  additions = final: _prev: import ../pkgs { pkgs = final; };
  modifications = final: prev: {
    spotdl = import ./spotdl.nix { inherit final prev; };
    caddy = prev.callPackage ../pkgs/mycaddy.nix {
      os = "linux";
      arch = "arm64";
      plugins = [ "github.com/caddy-dns/cloudflare" ];
      sha256 = "sha256-i5T6i1aiZ8XTZIQ6vHuOwvv/jdt4XdB+COROeWfNiIY=";
    };
  };
}
