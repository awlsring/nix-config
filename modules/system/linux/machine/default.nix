{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.machine;
in {
  imports = [
    ./server.nix
    ./desktop.nix
  ];

  config = {
    system.stateVersion = "24.11";

    time.timeZone = "America/Los_Angeles";
  };
}
