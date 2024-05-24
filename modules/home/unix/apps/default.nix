{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    discord
    slack
    obsidian
    spotify
    _1password-gui
  ];
}