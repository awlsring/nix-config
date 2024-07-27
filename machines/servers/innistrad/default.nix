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
  ];

  # tmp work around
  desktop.wallpaper = ../../../wallpapers/shaded_landscape.jpg;

  # perfmorance monitoring tools
  environment.systemPackages = with pkgs; [bottom intel-gpu-tools];

  fileSystems.${localDir} = {
    device = "${nfsServer}:${remoteDir}";
    fsType = "nfs";
  };

  networking.hostName = hostname;
  jellyfin = {
    enable = true;
    intelTranscoding = true;
  };
}
