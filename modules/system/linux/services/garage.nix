{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: {
  # disabledModules = [
  #   "services/web-servers/garage.nix"
  # ];

  options = {
    garage = {
      enable = lib.mkEnableOption "enables garage";
      user = lib.mkOption {
        type = lib.types.str;
        default = "garage";
        description = "The user that garage will run as";
      };
    };
  };

  config = lib.mkIf config.garage.enable {
    sops.secrets = {
      "garage/rpc" = {
        owner = config.garage.user;
      };
      "garage/admin" = {
        owner = config.garage.user;
      };
      "garage/metrics" = {
        owner = config.garage.user;
      };
    };

    users = {
      users = {
        ${config.garage.user} = {
          isSystemUser = true;
          group = config.garage.user;
        };
      };
      groups = {
        ${config.garage.user} = {};
      };
    };

    systemd.services.garage.serviceConfig.User = config.garage.user;
    systemd.services.garage.serviceConfig.Group = config.garage.user;

    networking.firewall.allowedTCPPorts = [3900 3901 3902 3903 3904];

    services.garage = {
      enable = true;
      package = pkgs.unstable.garage_1_x;
      settings = {
        db_engine = "lmdb";
        replication_mode = "3";

        metadata_dir = "/var/lib/garage/meta";
        data_dir = "/var/lib/garage/data";

        rpc_bind_addr = "[::]:3901";
        rpc_secret_file = config.sops.secrets."garage/rpc".path;

        s3_api = {
          s3_region = "dws";
          api_bind_addr = "[::]:3900";
        };

        s3_web = {
          bind_addr = "[::]:3902";
          root_domain = "drigs.org";
        };

        k2v_api = {
          api_bind_addr = "[::]:3904";
        };

        admin = {
          api_bind_addr = "[::]:3903";
          admin_token_file = config.sops.secrets."garage/admin".path;
          metrics_token_file = config.sops.secrets."garage/metrics".path;
        };
      };
    };
  };
}
