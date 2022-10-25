{ inputs, ... }:
{
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
    ./global.nix
    ./features/desktop
    ./features/nvim
  ];

  home.persistence."/persist/home/thomas" = {
    directories = [
      # must have at least one bind mount
      "Workspace"
      {
        directory = ".config/BraveSoftware/";
        method = "symlink";
      }
    ];

    files = [
      ".config/monitors.xml"
    ];

    allowOther = true;
  };
}
