{
  pkgs,
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.zsh.enable {
    programs.kitty = {
      enable = true;
      shellIntegration.enableZshIntegration = true;
      settings = {
        confirm_os_window_close = "0";
        background_opacity = lib.mkForce "0.7";
        allow_remote_control = "yes";
        shell_integration = "enabled";
      };
      font.size = lib.mkForce 14;
    };
  };
}
