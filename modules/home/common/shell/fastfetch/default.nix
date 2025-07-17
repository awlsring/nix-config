{
  pkgs,
  config,
  lib,
  ...
}: {
  # options.shell.fastfetch.enable = lib.mkEnableOption "enables zsh";
  options.shell.fastfetch.disable = lib.mkEnableOption "disables fastfetch";

  config = lib.mkIf (!config.shell.fastfetch.disable) {
    programs.fastfetch = {
      enable = true;
      package = pkgs.fastfetch;
      settings = {
        modules = [
          "title"
          "break"
          {
            type = "os";
            key = "os";
            format = "{3}";
          }
          {
            type = "host";
            key = "host";
          }
          {
            type = "kernel";
            key = "kernel";
          }
          {
            type = "uptime";
            key = "uptime";
          }
          {
            type = "shell";
            key = "shell";
          }
          {
            type = "terminal";
            key = "term";
          }
          {
            type = "localip";
            key = "local ip";
          }
          "break"
          {
            type = "cpu";
            key = "cpu";
            format = "{1}";
          }
          {
            type = "gpu";
            key = "gpu";
            format = "{2}";
          }
          {
            type = "cpuusage";
            key = "cpu usage";
            format = "{1}";
          }
          {
            type = "memory";
            key = "memory";
            format = "{1} / {2}";
          }
          {
            type = "disk";
            key = "disk";
            format = "{1} / {2} ({9})";
          }
          {
            type = "battery";
            key = "battery";
          }
        ];
      };
    };
  };
}
