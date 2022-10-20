{ lib, ... }:
{
  programs.fish = {
    enable = true;
    
    shellAliases = {
      g = "git";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      hms = "home-manager switch --flake ~/Documents/tstachl/h#$USER@$(hostname)";
    };

    interactiveShellInit = lib.mkAfter ''
      function d
        set target ~/Documents/$argv[1]
        echo "Target: $target"

        if not test -d $target
          set repo (string split "/" $argv[1])
          echo "Repo: $repo"

          if not test -d ~/Documents/$repo[1]
            echo "creating directory ..."
            mkdir ~/Documents/$repo[1]
          end

          cd ~/Documents/$repo[1]
          git clone git@github.com:$argv[1]
        end

        cd $target
        nvim .
      end
    '';
  };
}
