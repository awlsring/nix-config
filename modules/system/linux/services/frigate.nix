{
  config,
  pkgs,
  lib,
  ...
}: let
  format = pkgs.formats.yaml {};

  cameraFormat = with lib.types;
    submodule {
      freeformType = format.type;
      options = {
        ffmpeg = {
          inputs = lib.mkOption {
            description = ''
              List of inputs for this camera.
            '';
            type = lib.types.listOf (submodule {
              freeformType = format.type;
              options = {
                path = lib.mkOption {
                  type = lib.types.string;
                  example = "rtsp://192.0.2.1:554/rtsp";
                  description = ''
                    Stream URL
                  '';
                };
                roles = lib.mkOption {
                  type = lib.types.listOf (lib.types.enum ["detect" "record" "rtmp"]);
                  example = literalExpression ''
                    [ "detect" "rtmp" ]
                  '';
                  description = ''
                    List of roles for this stream
                  '';
                };
              };
            });
          };
        };
      };
    };
in {
  options = {
    frigate = {
      enable = lib.mkEnableOption "enables frigate";
      coral = {
        enable = lib.mkEnableOption "enables coral tpu";
        type = lib.mkOption {
          type = lib.types.string;
          default = "usb";
          description = "Coral TPU type";
        };
      };
      record = {
        enable = lib.mkEnableOption "enables recording";
        retentionDays = lib.mkOption {
          type = lib.types.int;
          default = 7;
          description = "Number of days to keep recordings";
        };
        captureMode = lib.mkOption {
          type = lib.types.string;
          default = "all";
          description = "Capture mode";
        };
        eventRetentionDays = lib.mkOption {
          type = lib.types.int;
          default = 30;
          description = "Number of days to keep events";
        };
      };
      enableSnapshots = lib.mkEnableOption "enables snapshots";
      trackedObjects = lib.mkOption {
        type = lib.types.listOf lib.types.string;
        default = ["person"];
        description = "List of objects to track";
      };
      cameras = mkOption {
        type = attrsOf cameraFormat;
        description = ''
          Attribute set of cameras configurations.

          https://docs.frigate.video/configuration/cameras
        '';
      };
    };
  };

  config = lib.mkIf config.frigate.enable {
    # Frigate config
    services.frigate = {
      enable = true;
      hostname = "frigate";
      settings = {
        mqtt = {
          enable = true;
          host = "127.0.0.1";
        };
        detectors = {
          coral = lib.mkIf config.frigate.coral.enable {
            device = "edgetpu";
            type = config.frigate.coral.type;
          };
          ffmpeg = {
            hwaccel_args = "preset-vaapi";
          };
          birdseye = {
            enabled = true;
            mode = "continuous";
          };
          objects = {
            track = config.frigate.trackedObjects;
          };
          record = lib.mkIf config.frigate.record.enable {
            enabled = true;
            retain = {
              days = config.frigate.record.retentionDays;
              mode = config.frigate.record.captureMode;
            };
            events.retain.default = config.frigate.record.eventRetentionDays;
          };
          snapshots = lib.mkIf config.frigate.enableSnapshots {
            enabled = true;
          };
          cameras = config.frigate.cameras;
        };
      };
    };

    # MQTT Config
    services.mosquitto = {
      enable = true;
      listeners = [
        {
          acl = ["pattern readwrite #"];
          omitPasswordAuth = true;
          settings.allow_anonymous = true;
        }
      ];
    };

    networking.firewall = {
      enable = true;
      allowedTCPPorts = [1883];
    };
  };
}
