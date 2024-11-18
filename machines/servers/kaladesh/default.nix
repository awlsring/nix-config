{
  inputs,
  lib,
  config,
  pkgs,
  nfsServer,
  linuxModules,
  ...
}: let
  username = "awlsring";
  hostname = "kaladesh";
in {
  imports = [
    linuxModules.system
    ./hardware-configuration.nix
    ./docker-wyze-bridge.nix
  ];

  # machine config
  machine = {
    username = username;
    hostname = hostname;
  };

  # enable monitoring
  monitoring.node-exporter.enable = true;

  # deployment
  services.comin = {
    enable = true;
    hostname = hostname;
    exporter.openFirewall = true;
    remotes = [
      {
        name = "origin";
        url = "https://github.com/awlsring/nix-config.git";
        branches.main.name = "main";
      }
    ];
  };

  services.logrotate.enable = true; # rotate logs
  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
  };

  # add to tailnet
  tailscale.enable = true;

  # camera storage mount
  fileSystems."mnt/frigate" = {
    device = "${nfsServer}:/mnt/WD-6D-8T/frigate";
    fsType = "nfs";
  };

  services = {
    frigate = {
      enable = true;
    };
    mosquitto.enable = true;
    home-assistant.enable = true;
  };

  virtualisation.podman = {
    enable = true;
    autoPrune.enable = true;
    dockerCompat = true;
    defaultNetwork.settings = {
      dns_enabled = true;
    };
  };

  # Enable container name DNS for non-default Podman networks.
  # https://github.com/NixOS/nixpkgs/issues/226365
  networking.firewall.interfaces."podman+".allowedUDPPorts = [53];

  virtualisation.oci-containers.backend = "podman";

  networking.firewall.allowedTCPPorts = [80 443 5000];
}
