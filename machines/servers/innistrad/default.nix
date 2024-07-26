{
  inputs,
  lib,
  config,
  pkgs,
  nfsServer,
  remoteDir,
  ...
}: let
  mediaDir = /mnt/media;
in {
  imports = [
    ../../../modules/system
    ./hardware-configuration.nix
  ];

  # tmp work around
  desktop.wallpaper = ../../../../wallpapers/shaded_landscape.jpg;

  fileSystems.${mediaDir} = {
    device = "${nfsServer}:${mediaDir}";
    fsType = "nfs";
  };

  networking.hostName = "innistrad";
  jellyfin = {
    enable = true;
    mediaDir = mediaDir;
  };
}
