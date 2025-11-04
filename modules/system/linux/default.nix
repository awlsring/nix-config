inputs: {
  impermanence,
  disko,
  stylix,
  sops-nix,
  comin,
}: {...}: {
  imports = [
    disko.nixosModules.disko
    stylix.nixosModules.stylix
    sops-nix.nixosModules.sops
    ./services
    ./machine
    ./environments
    ../common
  ];
}
