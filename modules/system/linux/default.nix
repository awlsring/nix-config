{
  config,
  lib,
  stylix,
  impermanence,
  disko,
  sops-nix,
  ...
}: {
  imports = [
    impermanence.nixosModules.impermanence
    disko.nixosModules.disko
    stylix.nixosModules.stylix
    sops-nix.nixosModules.sops
    ./monitoring
    ./services
    ./impermanence
    ./machine
    ../common
  ];
}
