{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf (config.desktop.wallpaper != null) {
    # Append apple script to set wallpaper to user activation
    system.activationScripts.postUserActivation.text = lib.mkAfter ''
      osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"${config.desktop.wallpaper}\" as POSIX file"
    '';
  };
}
