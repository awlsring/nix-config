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

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    time.timeZone = "America/Los_Angeles";
  };
}
