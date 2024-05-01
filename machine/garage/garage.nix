{ config, inputs, pkgs, ... }:
let
  unstable = inputs.unstable.legacyPackages.x86_64-linux;
in
{
    environment.systemPackages = with unstable; [
        garage
    ];

    networking.firewall.allowedTCPPorts = [ 3900 3901 3902 ];

    services.garage = {
        enable = true;
        package = unstable.garage_1_x;
        environmentFile = pkgs.writeText "garage-env" ''
          GARAGE_RPC_SECRET=$(openssl rand -hex 32)
        '';
        settings = {
            db_engine = "lmdb";
            replication_mode = "3";

            rpc_bind_addr = "[::]:3901";

            s3_api = {
                s3_region = "dws";
                api_bind_addr = "[::]:3900";
            };

            s3_web = {
                bind_addr = "[::]:3902";
                root_domain = "drigs.org";
            };
        };
    };
}