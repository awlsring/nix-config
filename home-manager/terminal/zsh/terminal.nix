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
      listen_on = "unix:/tmp/kitty";
      shell_integration = "enabled";
    };
    theme = "Catppuccin-Mocha";
    font = {
      name = "JetBrains Mono Bold";
      package = pkgs.jetbrains-mono;
      size = 14;
    };
  };
}
