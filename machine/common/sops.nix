{ config, pkgs, inputs, ... }:
{
  imports = [
    inputs.sops-nix.nixosModules.Sops
  ];

  sops.defaultSopsFile = ../../secrets/sops.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "~/.config/sops/keys/age/keys.txt";
}