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

    # Nix Hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Sops
    sops-nix.url = "github:Mic92/sops-nix";

    # vscode-server
    vscode-server.url = "github:nix-community/nixos-vscode-server";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Disko
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Impermanence
    impermanence.url = "github:nix-community/impermanence";

    # SrvOS
    srvos = {
      url = "github:nix-community/srvos";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Comin
    comin = {
      url = "github:nlewo/comin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dynamic-ip-watcher = {
      url = "github:awlsring/dynamic-ip-watcher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-darwin,
    sops-nix,
    systems,
    stylix,
    disko,
    impermanence,
    srvos,
    comin,
    vscode-server,
    dynamic-ip-watcher,
    nixos-hardware,
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

    linuxModules = {
      system = {pkgs, ...} @ args: {
        imports = [
          (
            import ./modules/system/linux inputs {
              inherit stylix impermanence disko sops-nix comin;
            }
          )
        ];
      };
      home = {pkgs, ...} @ args: {
        imports = [
          (
            import ./modules/home/linux inputs {
              inherit stylix;
            }
          )
        ];
      };
    };

    darwinModules = {
      system = {pkgs, ...} @ args: {
        imports = [
          (
            import ./modules/system/darwin inputs {
              inherit stylix;
            }
          )
        ];
      };
      home = {pkgs, ...} @ args: {
        imports = [
          (
            import ./modules/home/darwin inputs {
              inherit stylix;
            }
          )
        ];
      };
    };

    wallpapers = import ./wallpapers;
  in {
    inherit lib;

    overlays = import ./overlays {inherit inputs;};
    packages = forEachSystem (pkgs: import ./pkgs {inherit pkgs;});
    formatter = forEachSystem (pkgs: pkgs.alejandra);

    linuxModules = linuxModules;
    darwinModules = darwinModules;

    wallpapers = wallpapers;

    # NixOS
    nixosConfigurations = {
      # Framework 13
      ched = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs outputs home-manager linuxModules wallpapers;
        };
        modules = [
          nixos-hardware.nixosModules.framework-amd-ai-300-series
          ./machines/workstations/ched
        ];
      };
      
      # Desktop - Chungus
      chungus = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs outputs home-manager linuxModules wallpapers;
        };
        modules = [
          vscode-server.nixosModules.default
          ./machines/workstations/chungus
        ];
      };
    };

    # macOS
    darwinConfigurations = {
      # M1 Max - Chad
      chad = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {
          inherit inputs outputs home-manager darwinModules wallpapers;
        };
        modules = [./machines/workstations/chad];
      };
      # M5 Prod - Chud
      chud = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {
          inherit inputs outputs home-manager darwinModules wallpapers;
        };
        modules = [./machines/workstations/chud];
      };
    };
  };
}
