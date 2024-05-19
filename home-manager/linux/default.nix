# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ../common.nix
    ../apps.nix
    ../gaming.nix
    ../tools.nix
    ../neovim
    ../terminal.nix
    ../zsh.nix
    ../desktop-environments/hyprland
  ];

  home = {
    username = "awlsring";
    homeDirectory = "/home/awlsring";
    sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "firefox";
      TERMINAL = "kitty";
    };
  };

  colorScheme = inputs.nix-colors.colorSchemes.tokyo-night-dark;
}
