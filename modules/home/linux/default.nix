inputs: {stylix}: {
  config,
  lib,
  pkgs,
  username,
  ...
}: {
  imports = [
    stylix.homeModules.stylix
    ./apps
    ./gaming
    ./hyprland
    # ./waybar
    ../common
  ];

  home = {
    username = username;
    homeDirectory = "/home/${username}";
  };
}
