{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.environments.hyprland;
in {
  options.environments.hyprland = {
    enable = lib.mkEnableOption "Hyprland-based Wayland desktop environment";

    withUWSM = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to start Hyprland through uwsm for portal/session integration.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      withUWSM = cfg.withUWSM;
    };

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
    };

    programs.hyprlock.enable = true;
    services.hypridle.enable = true;

    environment.systemPackages = with pkgs; [
      kitty
      pyprland
      hyprpicker
      hyprcursor
      hyprlock
      hypridle
      hyprpaper
      hyprsunset
      hyprpolkitagent
    ];
  };
}
