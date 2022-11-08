{ stdenv, lib, fetchurl, os ? "linux", arch ? "arm64", plugins ? [], sha256 ? "" }:
let
  plugs = lib.concatMapStringsSep "&" (plugin: "p=${plugin}") plugins;
in stdenv.mkDerivation rec {
  pname = "caddy";
  version = "2.6.2";

  src = fetchurl {
    url = "https://caddyserver.com/api/download?os=${os}&arch=${arch}&${plugs}";
    sha256 = sha256;
  };

  unpackPhase = "true";

  installPhase = ''
    mkdir -p $out/bin
    cp ${src} $out/bin/caddy
    chmod +x $out/bin/caddy
  '';
}

