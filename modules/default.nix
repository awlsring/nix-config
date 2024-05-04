{ config, pkgs, lib, ... }: {
  imports = [
    ./services/tailscale.nix
    ./services/garage.nix
    ./monitoring/node-exporter.nix
    ./monitoring/scrutiny-collector.nix
  ];
}