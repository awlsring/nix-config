{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [ 
    protontricks
    protonup
  ];

  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATH = "\${HOME}/.steam/root/compatibilitytools.d";
  };
}
