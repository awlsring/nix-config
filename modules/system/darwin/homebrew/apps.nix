{
  config,
  pkgs,
  lib,
  ...
}: {
  options.brew.apps = {
    extras = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of extra applications to install";
    };
  };

  config = lib.mkIf config.brew.enable {
    homebrew.casks =
      [
        "firefox"
        "discord"
        "slack"
        "spotify"
        "obsidian"
        "1password"
      ]
      ++ config.brew.apps.extras;
  };
}
