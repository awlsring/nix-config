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

  # host config
  networking.hostName = hostname;

  # perfmorance monitoring tools
  environment.systemPackages = with pkgs; [bottom intel-gpu-tools];

  # media mount
  fileSystems.${localDir} = {
    device = "${nfsServer}:${remoteDir}";
    fsType = "nfs";
  };

  # media server sync
  networking.firewall.allowedTCPPorts = [8384 22000];
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
  };

  # media server
  jellyfin = {
    enable = true;
    intelTranscoding = true;
    jellyseerr = true;
  };
}
