# Shell for bootstrapping flake-enabled nix and other tooling
{ pkgs ? let
    # If pkgs is not defined, instanciate nixpkgs from locked commit
    lock = (builtins.fromJSON (builtins.readFile ./flake.lock)).nodes.nixpkgs.locked;
    nixpkgs = fetchTarball {
      url = "https://github.com/nixos/nixpkgs/archive/${lock.rev}.tar.gz";
      sha256 = lock.narHash;
    };
  in
  import nixpkgs { overlays = [ ]; }
, ...
}: pkgs.mkShell {
  NIX_CONFIG = "experimental-features = nix-command flakes repl-flake";

  sopsPGPKeyDirs = [ 
    "${toString ./.}/keys/hosts"
    "${toString ./.}/keys/users"
  ];
  sopsCreateGPGHome = true;

  nativeBuildInputs = with pkgs; [
    nix
    home-manager
    git

    sops
    gnupg
    age
  ];
}
