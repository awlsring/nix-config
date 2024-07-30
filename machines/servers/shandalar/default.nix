{
  inputs,
  lib,
  config,
  pkgs,
  hostname,
  ...
}: {
  imports = [
    ../../../modules/system
    ./hardware-configuration.nix
    (import ./disko.nix {device = "/dev/sda";})
  ];

  # host config
  networking.hostName = hostname;
  services.logrotate.enable = true; # rotate logs
  system.autoUpgrade = {
    # allow auto-upgrade
    enable = true;
    allowReboot = true;
  };

  # add to tailnet
  tailscale.enable = true;

  impermanence.enable = true;
}
