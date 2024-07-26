{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    "yabai-de".sketchybar = {
      configFile = lib.mkOption {
        type = lib.types.path;
        default = ./config/.sketchybarrc;
        description = "The path to the config file";
      };
    };
  };

  config = lib.mkIf config."yabai-de".enable {
    services.sketchybar = {
      enable = false; # disable til I make something half decent
      config = ''
        ${builtins.readFile config."yabai-de".sketchybar.configFile}
      '';
    };
  };
}
