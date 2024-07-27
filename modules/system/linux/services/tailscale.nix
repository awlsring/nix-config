{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    tailscale = {
      enable = lib.mkEnableOption "enables tailscale";
      tag = lib.mkOption {
        type = lib.types.str;
        default = "nix";
        description = "The tag to advertise to the Tailscale network";
      };
      secret = lib.mkOption {
        type = lib.types.str;
        default = "tailscale/nix/secret";
        description = "The secret to use to authenticate with Tailscale";
      };
    };
  };

  config = lib.mkIf config.tailscale.enable {
    # make the tailscale command usable to users
    environment.systemPackages = [pkgs.tailscale];

    # enable the tailscale service
    services.tailscale.enable = true;

    sops.secrets.${config.tailscale.secret} = {};

    systemd.services.tailscale-autoconnect = {
      description = "Automatic connection to Tailscale";

      # make sure tailscale is running before trying to connect to tailscale
      after = ["network-pre.target" "tailscale.service"];
      wants = ["network-pre.target" "tailscale.service"];
      wantedBy = ["multi-user.target"];

      # set this service as a oneshot job
      serviceConfig.Type = "oneshot";

      # have the job run this shell script
      script = with pkgs; ''
        # wait for tailscaled to settle
        sleep 2

        # check if we are already authenticated to tailscale
        status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
        if [ $status = "Running" ]; then # if so, then do nothing
          exit 0
        fi

        # otherwise authenticate with tailscale
        ${tailscale}/bin/tailscale up --auth-key=$(cat ${config.sops.secrets."${config.tailscale.secret}".path})?preauthorized=true --advertise-tags=tag:${config.tailscale.tag}
      '';
    };

    networking.firewall = {
      # enable the firewall
      enable = true;

      # always allow traffic from your Tailscale network
      trustedInterfaces = ["tailscale0"];

      # allow the Tailscale UDP port through the firewall
      allowedUDPPorts = [config.services.tailscale.port];
    };
  };
}
