{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./neovim
    ./terminal/zsh
    ./tmux
    ./tools
    ./apps
    ./lazygit
  ];
}
