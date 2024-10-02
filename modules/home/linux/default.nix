{
  config,
  lib,
  pkgs,
  username,
  ...
}: {
  imports = [
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
