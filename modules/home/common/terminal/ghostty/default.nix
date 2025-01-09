{
  pkgs,
  config,
  lib,
  ...
}: {
  options.terminal.ghostty.enable = lib.mkEnableOption "enables kitty terminal";

  config = lib.mkIf config.terminal.kitty.enable {
    home.packages = with pkgs; [
      ghostty
    ];
  };
}
