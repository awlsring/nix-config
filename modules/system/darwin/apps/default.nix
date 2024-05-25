{ config, pkgs, lib, ... }: {

  options.apps = {
    enable = lib.mkEnableOption "enables desktop applications";
  };

  config = lib.mkIf config.apps.enable {
    homebrew.casks = [
      "firefox"
      "discord"
      "slack"
      "spotify"
      "obsidian"
      "1password"
    ];
  };
}