{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../../../modules/templates/k3s-worker.nix
    ./hardware-configuration.nix
  ];

  sops.secrets."k3s/token" = {};

  # lump secret, hostname
  templates.k3s-worker = {
    enable = true;
    hostname = "tarkir";
    serverAddress = "10.0.10.150";
    tokenPath = config.sops.secrets."k3s/token".path;
  };
}
