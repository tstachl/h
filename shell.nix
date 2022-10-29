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
  NIX_CONFIG = ''
    keep-outputs = true
    experimental-features = nix-command flakes repl-flake
  '';

      # "nixpkgs=${inputs.nixpkgs}"
      # "nixpkgs-unstable=${inputs.unstable}"
  shellHook = ''
    # gpg --list-keys i@t5.st || gpg --receive-keys DE749C31D060A160
    # echo "$( \
    #   gpg --list-keys \
    #   | grep DE749C31D060A160 -A 1 \
    #   | head -1 | tr -d '[:space:]' \
    # ):6:" | gpg --import-ownertrust;

    # echo "pinentry-program $(which pinentry)" > ~/.gnupg/gpg-agent.conf

    # export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    # export PINENTRY_USER_DATA="USE_CURSES=1"
    # export GPG_TTY=$(tty)

    # gpg-connect-agent reloadagent /bye
    # gpg-connect-agent updatestartuptty /bye
  '';

  nativeBuildInputs = with pkgs; [ nix ];
}

#   # nativeBuildInputs = with pkgs; [
#   #   nix
#   #   nixops
#   #   home-manager
#   #   git
#   #   git-crypt
#
#   #   sops
#   #   gnupg
#   #   pinentry
#   #   age
#   # ];
# }).env
