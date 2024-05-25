{ config, pkgs, libs, ... }: {

  options.apps = {
    enable = lib.mkEnableOption "enables tailscale";
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
  }
}