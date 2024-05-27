{inputs, ...}: {
  imports = [
    ./monitoring
    ./services
    inputs.stylix.nixosModules.stylix
    inputs.sops-nix.nixosModules.sops
  ];
}
