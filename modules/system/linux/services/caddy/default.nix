# yoinked from https://github.com/jdheyburn/nixos-configs/blob/b3d8d89f57a5fe079aa60326694edabded0d8979/modules/caddy/default.nix
{
  catalog,
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.caddy;

  caddyMetricsPort = 2019;
in {
  options = {
    caddy = {enable = mkEnableOption "Enable reverse proxy Caddy";};
  };

  config = mkIf cfg.enable {
    # Allow network access when building
    # https://mdleom.com/blog/2021/12/27/caddy-plugins-nixos/#xcaddy
    nix.settings.sandbox = false;

    networking.firewall.allowedTCPPorts = [
      80 # HTTP
      443 # HTTPS
      caddyMetricsPort
    ];

    services.caddy = {
      enable = true;
      package = pkgs.callPackage ./custom-caddy.nix {
        plugins = ["github.com/caddy-dns/cloudflare"];
      };
    };
  };
}
