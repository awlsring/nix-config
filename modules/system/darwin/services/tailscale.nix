{ config, pkgs, lib, ... }:
{
  options = {
    tailscale = {
      enable = lib.mkEnableOption "enables tailscale";
      tag = lib.mkOption {
        type = lib.types.str;
        default = "nix";
        description = "The tag to advertise to the Tailscale network";
      };
    };
  };

  config = lib.mkIf config.tailscale.enable {
    # make the tailscale command usable to users
    environment.systemPackages = [ pkgs.tailscale ];

    # enable the tailscale service
    services.tailscale.enable = true;

    # TODO: make secret name configurable
    # sops.secrets."tailscale/${config.tailscale.tag}/secret" = { };

    launchd.user.agents.tailscale-autoconnect = {
      serviceConfig = {
        StandardOutPath = "/tmp/tailscale-autoconnect.out";
        StandardErrorPath = "/tmp/tailscale-autoconnect.err";
        RunAtLoad = true;
        KeepAlive = false;
      };
      script = with pkgs; ''
        # wait for tailscaled to settle
        sleep 2

        # check if we are already authenticated to tailscale
        status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
        if [ $status = "Running" ]; then # if so, then do nothing
          exit 0
        fi


        # otherwise authenticate with tailscale
        # TODO: When sops-nix supports darwin, use it here to auto authenticate
        ${tailscale}/bin/tailscale up
      '';
    };
  };

}