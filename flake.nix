{
  description = "Nix Configs";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Sops
    sops-nix.url = "github:Mic92/sops-nix";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    unstable,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib // unstable.lib;
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#machine'
    inherit lib;
    nixosConfigurations = {
      # Garage Storage - Naya
      naya = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./machine/garage/naya];
      };
    };

    homeConfigurations = {
      "awlsring@naya" = lib.homeManagerConfiguration {
        modules = [./home-manager/home.nix];
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs outputs;
        };
      };
    };
  };
}