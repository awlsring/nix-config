{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    _1password-gui
    firefox
    slack
    discord
    vscode
  ];
}
