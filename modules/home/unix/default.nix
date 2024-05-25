{ lib, pkgs, ... }:
{
  imports = [
    ./neovim
    ./terminal/zsh
    ./tools
    ./apps
    ./lazygit
  ];
}