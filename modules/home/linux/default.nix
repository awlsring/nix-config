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
    ../common
  ];

  home = {
    username = username;
    homeDirectory = "/home/${username}";
  };
}
