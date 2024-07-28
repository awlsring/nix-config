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

  # host config
  networking.hostName = hostname;
  services.logrotrate.enable = true; # rotate logs
  system.autoUpgrade = {
    # allow auto-upgrade
    enable = true;
    allowReboot = true;
  };

  # add to tailnet
  tailscale.enable = true;

  # perfmorance monitoring tools
  environment.systemPackages = with pkgs; [bottom intel-gpu-tools];

  # media mount
  fileSystems.${localDir} = {
    device = "${nfsServer}:${remoteDir}";
    fsType = "nfs";
  };

  # media server sync
  syncthing.enable = true;

  # media server
  jellyfin = {
    enable = true;
    intelTranscoding = true;
    jellyseerr = true;
  };
}
