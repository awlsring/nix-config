{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.nginx-reverse-proxy;
in {
  options = {
    nginx-reverse-proxy = {
      enable = lib.mkEnableOption "enables tailscale";
      domain = lib.mkOption {
        type = lib.types.str;
        description = "The domain to use for the reverse proxy";
      };
      proxies = lib.mkOption {
        type = lib.types.listOf (lib.types.attrsOf {
          domain = lib.types.str;
          proxyTarget = lib.types.str;
          nginxExtraConfig = lib.types.str;
          extraNames = lib.types.listOf lib.types.str;
        });
        default = [];
        description = "List of reverse proxies with domain, target, extra config, and additional domains.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # reverse proxy
    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts =
        lib.foldl' (
          acc: proxy: let
            allDomains = [proxy.domain] ++ proxy.extraNames;
          in
            acc
            // lib.foldl' (accHosts: domain:
              accHosts
              // {
                "${domain}" = {
                  useACMEHost = proxy.domain; # Always use the main domain for ACME certificate
                  forceSSL = true;
                  locations."/".proxyPass = proxy.proxyTarget;
                  extraConfig = proxy.nginxExtraConfig;
                };
              }) {}
            allDomains
        ) {}
        cfg.proxies;
    };

    # certs
    sops.secrets."cloudflare/drigs/token" = {};
    security.acme = {
      acceptTerms = true;
      defaults = {
        email = "services@matthewrawlings.com";
        environmentFile = config.sops.secrets."cloudflare/drigs/token".path;
        dnsProvider = "cloudflare";
        dnsResolver = "1.1.1.1:53";
        dnsPropagationCheck = true;
        group = config.services.nginx.group;
      };
      certs = lib.foldl' (acc: proxy:
        acc
        // {
          "${proxy.domain}" = {
            domain = proxy.domain;
            extraDomainNames = proxy.extraNames;
          };
        }) {}
      cfg.proxies;
    };

    networking.firewall.allowedTCPPorts = [80 443];
  };
}
