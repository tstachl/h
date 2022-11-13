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
    brave = prev.brave.overrideAttrs (old: rec {
      version = "1.45.123";
      src = final.fetchurl {
        url = "https://github.com/brave/brave-browser/releases/download/v${version}/brave-browser_${version}_amd64.deb";
        sha256 = "sha256-h8UdQsh7JtcFnjseUaNztD2YoAfgWG2wmup2xsft6dU=";
      };
    });
  };
}
