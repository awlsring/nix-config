{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  options.gaming = {
    enable = lib.mkEnableOption "enables gaming applications";
  };

  config = lib.mkIf config.gaming.enable {
    home.packages = with pkgs; [ 
      protontricks
      protonup
    ];

    home.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATH = "\${HOME}/.steam/root/compatibilitytools.d";
    };
  };
}
