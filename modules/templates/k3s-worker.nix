{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.templates.k3s-worker;
in {
  imports = [
    ../system
  ];

  options.templates.k3s-worker = {
    enable = lib.mkEnableOption "enables k3s-worker modules";
    hostname = lib.mkOption {
      type = lib.types.str;
      description = "The hostname of the k3s worker";
    };
    serverAddress = lib.mkOption {
      type = lib.types.str;
      description = "The address of the k3s server";
    };
    tokenPath = lib.mkOption {
      type = lib.types.path;
      description = "path to file containing token";
    };
  };

  config = lib.mkIf cfg.enable {
    # set hostname
    networking.hostName = cfg.hostname;

    # disable firewall
    networking.firewall.enable = false;

    # allow open iscsi
    services.openiscsi = {
      enable = true;
      name = "${config.networking.hostName}-initiatorhost";
    };
    services.target.enable = true;

    # enable k3s
    services.k3s = {
      enable = true;
      package = pkgs.k3s;
      role = "agent";
      serverAddr = "${cfg.serverAddress}:6443";
      tokenFile = cfg.tokenPath;
      extraFlags = "--flannel-backend=none --disable-network-policy";
    };
    environment.systemPackages = [pkgs.nfs-utils];
    networking.firewall.allowedTCPPorts = [6443];
  };
}
