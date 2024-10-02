# Darwin specific configs for the stylixed modules
{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf config.stylixed.enable {
    # Append apple script to set wallpaper to user activation
    system.activationScripts.postUserActivation.text = lib.mkAfter ''
      osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"${config.stylixed.wallpaper}\" as POSIX file"
    '';
  };
}
