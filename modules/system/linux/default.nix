{
  config,
  lib,
  stylix,
  impermanence,
  disko,
  sops-nix,
  comin,
  ...
}: {
  imports = [
    impermanence.nixosModules.impermanence
    disko.nixosModules.disko
    stylix.nixosModules.stylix
    sops-nix.nixosModules.sops
    comin.nixosModules.comin
    ./monitoring
    ./services
    ./impermanence
    ./machine
    ../common
  ];
}
