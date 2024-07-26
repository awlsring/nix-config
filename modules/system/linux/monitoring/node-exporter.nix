{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    "node-exporter" = {
      enable = lib.mkEnableOption "enables prometheus node exporter";
      port = lib.mkOption {
        type = lib.types.int;
        default = 9100;
        description = "The port to listen on";
      };
      collectors = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = ["systemd"];
        description = "The collectors to enable";
      };
    };
  };

  config = lib.mkIf config."node-exporter".enable {
    services.prometheus.exporters.node = {
      enable = true;
      enabledCollectors = config."node-exporter".collectors;
      port = config."node-exporter".port;
    };
  };
}
