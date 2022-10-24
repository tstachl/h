{
  description = "My Device Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    hardware.url = "github:nixos/nixos-hardware";
    impermanence.url = "github:nix-community/impermanence";
    nur.url = "github:nix-community/nur";
    brave.url = "github:tstachl/nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixos-generators, ... }@inputs:
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
      };

      images = {
        odin = nixos-generators.nixosGenerate {
          system = "aarch64-linux";
          specialArgs = { inherit inputs; inherit (self) outputs; };
          modules = [ ./hosts/odin ];
          format = "sd-aarch64-installer";
        };
      };
    };
}
