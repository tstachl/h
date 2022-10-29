{
  description = "my configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    brave.url = "github:tstachl/nixpkgs";

    hardware.url = "github:nixos/nixos-hardware";
    impermanence.url = "github:nix-community/impermanence";
    nur.url = "github:nix-community/nur";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, unstable, home-manager, ... }@inputs:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "aarch64-darwin"
        "i686-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      pkgsFor = forAllSystems (system:
        import unstable {
          inherit system;

          config = {
            allowUnfree = true;
            allowUnsupportedSystem = true;
          };
        }
      );
    in
    rec {
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      packages = forAllSystems (system:
        import ./pkgs { pkgs = pkgsFor.${system}; }
      );
      devShells = forAllSystems (system: {
        default = import ./shell.nix { pkgs = pkgsFor.${system}; };
      });

      nixosConfigurations = {
        throwaway = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = { inherit inputs; inherit (self) outputs; };
          modules = [ ./hosts/throwaway ];
        };

        odin = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = { inherit inputs; inherit (self) outputs; };
          modules = [ ./hosts/odin ];
        };

        penguin = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; inherit (self) outputs; };
          modules = [ ./hosts/penguin ];
        };
      };

      homeConfigurations = {
        "thomas@throwaway" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor."aarch64-linux";
          extraSpecialArgs = { inherit inputs; inherit (self) outputs; };
          modules = [ ./home/thomas/throwaway.nix ];
        };

        "thomas@odin" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor."aarch64-linux";
          extraSpecialArgs = { inherit inputs; inherit (self) outputs; };
          modules = [ ./home/thomas/odin.nix ];
        };

        "thomas@penguin" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor."x86_64-linux";
          extraSpecialArgs = { inherit inputs; inherit (self) outputs; };
          modules = [ ./home/thomas/penguin.nix ];
        };
      };
    };
}
