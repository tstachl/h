{
  description = "my configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";

    hardware.url = "github:nixos/nixos-hardware";
    impermanence.url = "github:nix-community/impermanence";
    nur.url = "github:nix-community/nur";
    agenix.url = "github:ryantm/agenix";
  };

  outputs = { self, nixpkgs, darwin, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    rec {
      nixosModules = import ./modules/nixos;
      darwinModules = import ./modules/darwin;
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
        # Raspberry Pi in Austria
        # odin = nixpkgs.lib.nixosSystem {
        #   system = "aarch64-linux";
        #   specialArgs = { inherit inputs; inherit (self) outputs; };
        #   modules = [ ./hosts/odin ];
        # };

        # VPS in Chile
        thor = nixpkgs.lib.nixosSystem {
          pkgs = legacyPackages."aarch64-linux";
          specialArgs = { inherit inputs; inherit (self) outputs; };
          modules = [ ./hosts/thor ];
        };

        # penguin = nixpkgs.lib.nixosSystem {
        #   pkgs = legacyPackages."x86_64-linux";
        #   specialArgs = { inherit inputs; inherit (self) outputs; };
        #   modules = [ ./hosts/penguin ];
        # };

        # odin = nixpkgs.lib.nixosSystem {
        #   pkgs = legacyPackages."aarch64-linux";
        #   specialArgs = { inherit inputs; inherit (self) outputs; };
        #   modules = [
        #     ./hosts/odin    # configuration for the host itself
        #     ./services/git  # user configuration for git server
        #     ./users/thomas  # user configuration for thomas
        #   ];
        # };
      };

      darwinConfigurations = {
        meili = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs; inherit (self) outputs; };
          modules = [
            ./hosts/meili

          ];
        };
      };

      homeConfigurations = {
        "thomas@meili" = home-manager.lib.homeManagerConfiguration {
          pkgs = legacyPackages."aarch64-darwin";
          extraSpecialArgs = { inherit inputs; inherit (self) outputs; };
          modules = [ ./home/thomas/meili.nix ];
        };
      };
    };
}
