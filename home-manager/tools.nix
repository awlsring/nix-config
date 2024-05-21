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
  home.packages = with pkgs; [
    # utils
    bc
    bottom
    bat
    ripgrep
    fd
    httpie
    jq
    awscli2
    _1password
    kitty
    alejandra
    tmux
    yazi
    starship
    eza

    # kubernetes
    kubectl
    k9s
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "awlsring";
    userEmail = "contact@matthewrawlings.com";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
