{
  pkgs,
  config,
  lib,
  ...
}: {
  options.terminal.kitty.enable = lib.mkEnableOption "enables kitty terminal";

  config = lib.mkIf config.terminal.kitty.enable {
    programs.kitty = {
      enable = true;
      shellIntegration.enableZshIntegration = config.shell.zsh.enable;
      settings = {
        confirm_os_window_close = "0";
        background_opacity = lib.mkForce "0.7";
        allow_remote_control = "yes";
        shell_integration = "enabled";
      };
      font.name = lib.mkForce "JetBrains Mono";
      font.size = lib.mkForce 14;
    };
  };
}
