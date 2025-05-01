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
    masExtras = lib.mkOption {
      type = lib.types.attrsOf lib.types.int;
      default = {};
      description = "Additional MAS apps to install.";
    };
  };

  config = lib.mkIf config.brew.enable {
    homebrew.casks =
      [
        "claude"
        "firefox"
        "discord"
        "slack"
        "spotify"
        "obsidian"
        "1password"
        "alfred"
        "ghostty"
      ]
      ++ config.brew.apps.extras;

    homebrew.masApps = lib.mkMerge [
      {
        "Boop" = 1518425043;
        "1Password for Safari" = 1569813296;
      }
      config.brew.apps.masExtras
    ];
  };
}
