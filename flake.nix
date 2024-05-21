{
  description = "Nix Configs";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    # Nix Darwin
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Nix Colors
    nix-colors.url = "github:misterio77/nix-colors";

    # Stylix
    stylix.url = "github:danth/stylix";

    # Hyprland
    hyprland.url = "github:hyprwm/Hyprland";

    # Nix Systems
    systems.url = "github:nix-systems/default";

    # Sops
    sops-nix.url = "github:Mic92/sops-nix";

    # vscode-server
    vscode-server.url = "github:nix-community/nixos-vscode-server";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-darwin,
    systems,
    stylix,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;
    forEachSystem = f: lib.genAttrs (import systems) (system: f pkgsFor.${system});
    pkgsFor = lib.genAttrs (import systems) (
      system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
    );
  in {
    inherit lib;

    overlays = import ./overlays {inherit inputs;};
    packages = forEachSystem (pkgs: import ./pkgs {inherit pkgs;});
    formatter = forEachSystem (pkgs: pkgs.alejandra);

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild switch --flake .#machine'
    nixosConfigurations = {
      # Workstation - Toes
      toes = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./machine/workstation/toes
          ./modules
        ];
      };
      # Workstation - Chungus
      chungus = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./machine/workstation/chungus
          ./modules
        ];
      };
      # Garage Storage - Naya
      naya = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./machine/garage/naya
          ./modules
        ];
      };
    };

    # MacBook
    darwinConfigurations = {
      chad = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./modules/darwin
          ./machine/workstation/chad
          home-manager.darwinModules.home-manager {
            home-manager.extraSpecialArgs = {
              inherit inputs outputs;
            };
            home-manager.users.awlsring = import ./home-manager/darwin;
          }
        ];
      };
    };

    homeConfigurations = {
      "awlsring@chad" = lib.homeManagerConfiguration {
        modules = [./home-manager/darwin];
        pkgs = pkgsFor.aarch64-darwin;
        extraSpecialArgs = {
          inherit inputs outputs;
        };
      };
      "awlsring@toes" = lib.homeManagerConfiguration {
        modules = [./home-manager/linux];
        pkgs = pkgsFor.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs outputs;
        };
      };
      "awlsring@chungus" = lib.homeManagerConfiguration {
        modules = [stylix.homeManagerModules.stylix ./home-manager/linux];
        pkgs = pkgsFor.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs outputs;
        };
      };
      "awlsring@naya" = lib.homeManagerConfiguration {
        modules = [./home-manager/linux];
        pkgs = pkgsFor.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs outputs;
        };
      };
    };
  };
}
