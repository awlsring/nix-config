{ config, pkgs, lib, ... }: {
  imports = [
    ./services/tailscale.nix
    ./monitoring/node-exporter.nix
    ./monitoring/scrutiny-collector.nix
  ];
}