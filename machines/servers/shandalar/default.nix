{
  inputs,
  lib,
  config,
  pkgs,
  hostname,
  nfsServer,
  remoteDir,
  localDir,
  ...
}: {
  imports = [
    ../../../modules/system
    ./hardware-configuration.nix
    ./disko.nix
    {device = "/dev/sda";}
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
}
