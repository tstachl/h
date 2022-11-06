{
  additions = final: _prev: import ../pkgs { pkgs = final; };
  modifications = final: prev: {
    spotdl = import ./spotdl.nix { inherit final prev; };
  };
}
