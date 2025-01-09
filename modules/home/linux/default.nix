inputs: {stylix}: {
  config,
  lib,
  pkgs,
  username,
  ...
}: {
  imports = [
    stylix.homeManagerModules.stylix
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
