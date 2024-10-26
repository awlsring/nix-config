{
  inputs,
  lib,
  config,
  pkgs,
  linuxModules,
  ...
}: let
  username = "rawlings";
  hostname = "ulgrotha";
in {
  imports = [
    linuxModules.system
    ./hardware-configuration.nix
  ];

  # machine config
  machine = {
    username = username;
    hostname = hostname;
  };

  # enable monitoring
  monitoring.node-exporter.enable = true;

  # host config
  services.logrotate.enable = true; # rotate logs
  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
  };

  # add to tailnet
  tailscale.enable = true;

  # perfmorance monitoring tools
  environment.systemPackages = with pkgs; [bat bottom intel-gpu-tools];
}
