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
      # Workstation - Chungus
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

      # Jellyfin - Innistrad
      innistrad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          nfsServer = "10.0.10.180";
          remoteDir = "/mnt/WD-6D-8T/fin";
          localDir = "/mnt/media";
          inherit inputs outputs linuxModules;
        };
        modules = [
          srvos.nixosModules.server
          dynamic-ip-watcher.nixosModules.dynamic-ip-watcher
          ./machines/servers/innistrad
        ];
      };

      # Public Reverse Proxy - Conflux
      conflux = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs outputs linuxModules;
        };
        modules = [
          disko.nixosModules.disko
          srvos.nixosModules.server
          srvos.nixosModules.hardware-hetzner-cloud
          ./machines/servers/conflux
        ];
      };

      # Dominaria
      dominaria = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs outputs linuxModules;
        };
        modules = [
          disko.nixosModules.disko
          srvos.nixosModules.server
          ./machines/servers/dominaria
        ];
      };

      # Kaladesh
      kaladesh = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          nfsServer = "10.0.10.180";
          remoteDir = "/mnt/WD-6D-8T/frigate";
          inherit inputs outputs linuxModules;
        };
        modules = [./machines/servers/kaladesh];
      };

      # Ulgrotha
      ulgrotha = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs outputs linuxModules;
        };
        modules = [./machines/servers/ulgrotha];
      };
    };

    # macOS
    darwinConfigurations = {
      # Workstation - Chad
      chad = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {
          inherit inputs outputs home-manager darwinModules wallpapers;
        };
        modules = [./machines/workstations/chad];
      };
    };
  };
}
