{ config, ... }: let
  cfg = config.machine;
in {
  # Sops
  sops = {
    defaultSopsFile = ../../../../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/${cfg.username}/.config/sops/age/keys.txt";
  };
}