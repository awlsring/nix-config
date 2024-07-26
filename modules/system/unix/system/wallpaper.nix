{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    desktop = {
      wallpaper = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "The path to the wallpaper image to use for the system";
      };
    };
  };
}
