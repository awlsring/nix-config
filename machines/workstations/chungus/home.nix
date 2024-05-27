{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  wallpaper,
  ...
}: {
  imports = [
    ../../../modules/home
  ];

  # linux modules
  apps.enable = true;
  gaming.enable = true;
  hyprland.enable = true;

  # unix modules
  tools.enable = true;
  zsh.enable = true;
  neovim.enable = true;
  tmux.enable = true;
  lazygit.enable = true;
}
