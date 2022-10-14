{
  description = "My Device Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "aarch64-darwin"
        "i686-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      pkgsFor = forAllSystems (system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          config.allowUnsupportedSystem = true;
        }
      );
    in
    rec {
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      devShells = forAllSystems (system: {
        default = import ./shell.nix { pkgs = pkgsFor.${system}; };
      });

      nixosConfigurations = {
        throwaway = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = { inherit inputs; inherit (self) outputs; };
          modules = [ ./hosts/throwaway ];
        };
      };

      homeConfigurations = {
        "thomas@throwaway" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor."aarch64-linux";
          extraSpecialArgs = { inherit inputs; inherit (self) outputs; };
          modules = [ ./home/thomas/throwaway.nix ];
        };
      };

    };
}
