{
  description = "backsnap";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    naersk.url = "github:nix-community/naersk";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, naersk, utils, ... }@inputs:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        naersk' = pkgs.callPackage naersk {};
      in rec {
        defaultPackage = naersk'.buildPackage { src = ./.; };
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [ cargo rustc ];
        };
      }
    );
}
