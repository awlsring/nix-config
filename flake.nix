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

    # deploy-rs
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-darwin,
    sops-nix,
    systems,
    stylix,
    deploy-rs,
    disko,
    impermanence,
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

    nixosModules = {};
    darwinModules = {
      system = (
        import ./modules/system/darwin {
          inherit (nixpkgs) config pkgs lib;
          inherit stylix;
        }
      );
      home = import ./modules/home/darwin;
    };
  in {
    inherit lib;

    overlays = import ./overlays {inherit inputs;};
    packages = forEachSystem (pkgs: import ./pkgs {inherit pkgs;});
    formatter = forEachSystem (pkgs: pkgs.alejandra);

    # NixOS
    nixosConfigurations = let
      hostType = "nixos";
    in {
      # Workstation - Chungus
      chungus = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          username = "awlsring";
          inherit inputs outputs hostType home-manager stylix sops-nix disko impermanence;
        };
        modules = [./machines/workstations/chungus];
      };

      # K3S Node - Tarkir
      tarkir = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          username = "k3s";
          inherit inputs outputs hostType home-manager stylix sops-nix disko impermanence;
        };
        modules = [./machines/servers/k3s/tarkir];
      };

      # Jellyfin - Innistrad
      innistrad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          username = "fin";
          hostname = "innistrad";
          nfsServer = "10.0.10.180";
          remoteDir = "/mnt/WD-6D-8T/fin";
          localDir = "/mnt/media";
          inherit inputs outputs hostType home-manager stylix sops-nix disko impermanence;
        };
        modules = [./machines/servers/innistrad];
      };

      # Test - Shandalar
      shandalar = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          username = "awlsring";
          hostname = "shandalar";
          inherit inputs outputs hostType home-manager stylix sops-nix disko impermanence;
        };
        modules = [./machines/servers/shandalar];
      };
    };

    # Linux (non-NixOS)
    homeConfigurations = let
      hostType = "linux";
    in {
      roach = lib.homeManagerConfiguration {
        pkgs = pkgsFor.x86_64-linux;
        extraSpecialArgs = {
          username = "rawmatth";
          inherit inputs outputs hostType home-manager stylix;
        };
        modules = [./machines/workstations/roach];
      };
    };

    # Macs (Darwin)
    darwinConfigurations = {
      chad = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {
          inherit inputs outputs home-manager stylix darwinModules;
        };
        modules = [./machines/workstations/chad];
      };
      peccy = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {
          username = "rawmatth";
          inherit inputs outputs home-manager stylix darwinModules;
        };
        modules = [./machines/workstations/peccy];
      };
    };

    # Deployments
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    deploy.nodes = {
      innistrad = {
        hostname = "innistrad";
        profiles.system = {
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.innistrad;
          sshUser = "fin";
          remoteBuild = true;
        };
      };
    };
  };
}
