{
  inputs,
  lib,
  config,
  pkgs,
  hostname,
  nfsServer,
  remoteDir,
  localDir,
  ...
}: let
  jellyfinDomain = "fin.us-drig-1.drigs.org";
  jellyfinPublic = "fin.drigs.org";
  jellySeerDomain = "requests.us-drig-1.drigs.org";
in {
  imports = [
    ../../../modules/system
    ./hardware-configuration.nix
  ];

  # host config
  networking.hostName = hostname;
  services.logrotate.enable = true; # rotate logs
  system.autoUpgrade = {
    # allow auto-upgrade
    enable = true;
    allowReboot = true;
  };

  # add to tailnet
  tailscale.enable = true;

  # perfmorance monitoring tools
  environment.systemPackages = with pkgs; [bottom intel-gpu-tools];

  # media mount
  fileSystems.${localDir} = {
    device = "${nfsServer}:${remoteDir}";
    fsType = "nfs";
  };

  # media server sync
  syncthing.enable = true;

  # media server
  jellyfin = {
    enable = true;
    intelTranscoding = true;
    jellyseerr = true;
  };

  # reverse proxy
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      ${jellyfinDomain} = {
        useACMEHost = jellyfinDomain;
        forceSSL = true;
        locations."/".proxyPass = "http://127.0.0.1:8096";
        extraConfig = ''
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection $http_connection;
        '';
      };
      ${jellySeerDomain} = {
        useACMEHost = jellySeerDomain;
        forceSSL = true;
        locations."/".proxyPass = "http://127.0.0.1:5055";
      };
    };
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
    certs = {
      ${jellyfinDomain} = {
        domain = jellyfinDomain;
        extraDomainNames = [jellyfinPublic];
      };
      ${jellySeerDomain} = {
        domain = jellySeerDomain;
      };
    };
  };

  networking.firewall.allowedTCPPorts = [80 443];
}
