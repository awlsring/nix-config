{pkgs ? import <nixpkgs> {}, ...}: rec {
  # Nix scripts
  nix-rebuild = pkgs.callPackage ./nix-rebuild {};
}