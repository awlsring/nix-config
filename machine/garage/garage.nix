{ config, inputs, pkgs, ... }:
let
  unstable = inputs.unstable.legacyPackages.x86_64-linux;
  garageUser = "garage";
in
{
    environment.systemPackages = with unstable; [
        garage
    ];

    sops.secrets = {
        "garage/rpc" = {
            owner = garageUser;
        };
        "garage/admin" = {
            owner = garageUser;
        };
        "garage/metrics" = {
            owner = garageUser;
        };
    };

    users = {
        users = {
            ${garageUser} = {
                isSystemUSer = true;
                group = garageUser;
            };
        };
        groups = {
            ${garageUser} = { };          
        };
    };

    systemd.services.garage.serviceConfig.User = garageUser;
    systemd.services.garage.serviceConfig.Group = garageUser;

    networking.firewall.allowedTCPPorts = [ 3900 3901 3902 ];

    services.garage = {
        enable = true;
        package = unstable.garage_1_x;
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
}