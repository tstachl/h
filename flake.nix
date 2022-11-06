{
  description = "my configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    brave.url = "github:tstachl/nixpkgs";

    home-manager.url = "github:nix-community/home-manager";

    hardware.url = "github:nixos/nixos-hardware";
    impermanence.url = "github:nix-community/impermanence";
    nur.url = "github:nix-community/nur";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      inherit (self) outputs;
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    rec {
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;
      overlays = import ./overlays;

      legacyPackages = forAllSystems (system:
        import nixpkgs {
          inherit system;
          overlays = with outputs.overlays; [ additions modifications ];
          config.allowUnfree = true;
          config.allowUnsupportedSystem = true;
        }
      );

      packages = forAllSystems (system:
        import ./pkgs { pkgs = legacyPackages.${system}; }
      );
      devShells = forAllSystems (system: {
        default = import ./shell.nix { pkgs = legacyPackages.${system}; };
      });

      nixosConfigurations = {
        throwaway = nixpkgs.lib.nixosSystem {
          pkgs = legacyPackages."aarch64-linux";
          specialArgs = { inherit inputs; inherit (self) outputs; };
          modules = [ ./hosts/throwaway ];
        };

        # odin = nixpkgs.lib.nixosSystem {
        #   system = "aarch64-linux";
        #   specialArgs = { inherit inputs; inherit (self) outputs; };
        #   modules = [ ./hosts/odin ];
        # };

        thor = nixpkgs.lib.nixosSystem {
          pkgs = legacyPackages."aarch64-linux";
          specialArgs = { inherit inputs; inherit (self) outputs; };
          modules = [ ./hosts/thor ];
        };

        # penguin = nixpkgs.lib.nixosSystem {
        #   system = "x86_64-linux";
        #   specialArgs = { inherit inputs; inherit (self) outputs; };
        #   modules = [ ./hosts/penguin ];
        # };
      };

      # Using NixOS module instead of home-manager because `sessionVariables`
      # won't work otherwise.
      homeConfigurations = {
        # "thomas@throwaway" = home-manager.lib.homeManagerConfiguration {
        #   pkgs = pkgsFor."aarch64-linux";
        #   extraSpecialArgs = { inherit inputs; inherit (self) outputs; };
        #   modules = [ ./home/thomas/throwaway.nix ];
        # };
      };
    };
}
