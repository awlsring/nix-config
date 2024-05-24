{
  pkgs,
  config,
  lib,
  ...
}: {
  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    settings = {
      background_opacity = lib.mkForce "0.6";
      allow_remote_control = "yes";
      shell_integration = "enabled";
    };
    font.size = lib.mkForce 14;
  };
}
