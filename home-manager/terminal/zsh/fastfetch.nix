{
  pkgs,
  config,
  lib,
  ...
}: {
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
        "break"
        {
          type = "localip";
          key = "local ip";
        }
        {
          type = "wifi";
          key = "wifi";
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
          key = "cpu usage%";
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
        {
          type = "poweradapter";
          key = "power";
        }
      ];
    };
  };
}
