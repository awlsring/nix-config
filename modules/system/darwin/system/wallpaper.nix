{ config, pkgs, lib, ... }:
{
  options = {
    desktop = {
      wallpaper = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "The path to the wallpaper image";
      };
    };
  };

  config = lib.mkIf (config.desktop.wallpaper != null) {
    system.activationScripts.postUserActivation.text = lib.mkAfter ''
      osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"${config.desktop.wallpaper}\" as POSIX file"
    '';
  };
}