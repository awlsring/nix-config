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
  ];

  home = {
    username = username;
    homeDirectory = "/home/${username}";
  };
}
