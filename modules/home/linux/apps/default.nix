{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  options.apps = {
    enable = lib.mkEnableOption "enables desktop apps";
  };

  config = lib.mkIf config.apps.enable {
    home.packages = with pkgs; [
      discord
      obsidian
      spotify
      _1password-gui
      firefox
      brave
      vscode
      # vscodium
    ];
  };
}
