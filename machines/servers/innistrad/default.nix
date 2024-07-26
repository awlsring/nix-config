{
  inputs,
  lib,
  config,
  pkgs,
  nfsServer,
  remoteDir,
  ...
}: {
  imports = [
    ../../../modules/system
    ./hardware-configuration.nix
  ];

  # tmp work around
  desktop.wallpaper = ../../../wallpapers/shaded_landscape.jpg;

  fileSystems.${mediaDir} = {
    device = "${nfsServer}:${remoteDir}";
    fsType = "nfs";
  };

  networking.hostName = "innistrad";
  jellyfin = {
    enable = true;
  };
}
