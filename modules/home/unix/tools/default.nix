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
    # utils
    bc
    bottom
    ripgrep
    fd
    httpie
    jq
    awscli2
    _1password
    alejandra
    tmux
    sops

    # kubernetes
    kubectl
    k9s

    # nix utils
    nix-rebuild
  ];

  # Enable home-manager and git
  programs = {
    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [ batman ];
    };
    git.enable = true;
    gpg.enable = true;
  };
}