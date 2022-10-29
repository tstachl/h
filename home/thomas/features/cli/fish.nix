{ lib, ... }:
{
  home.sessionVariables = {
    PASSWORD_STORE_DIR = "~";
    PASSWORD_STORE_KEY = "test";
  };

  programs.fish = {
    enable = true;

    shellAliases = {
      g = "git";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      hms = "home-manager switch --flake ~/Workspace/tstachl/h#$USER@$(hostname)";
    };

    interactiveShellInit = lib.mkAfter ''
      function d -d "Develop on the given repository"
        set loc ~/Workspace
        set target $loc/$argv[1]

        if not test -d $target
          set repo (string split "/" $argv[1])

          if not test -d $loc/$repo[1]
            echo "creating directory ..."
            mkdir $loc/$repo[1]
          end

          cd $loc/$repo[1]
          git clone git@github.com:$argv[1]
        end

        if test -d $target
          cd $target
          nvim .
        end
      end
    '';
  };
}
