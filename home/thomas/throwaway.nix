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
      "Downloads"
      "Music"
      "Pictures"
      "Documents"
      "Videos"
      {
        directory = ".config/BraveSoftware/";
        method = "symlink";
      }
    ];

    allowOther = true;
  };
}
