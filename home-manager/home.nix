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
  # You can import other home-manager modules here
  imports = [
    # inputs.vscode-server.nixosModules.default
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  home = {
    username = "awlsring";
    homeDirectory = "/home/awlsring";
  };

  nixpkgs = {
    # You can add overlays here
    overlays = [
     outputs.overlays.additions
     outputs.overlays.modifications
     outputs.overlays.unstable-packages
    ];
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  # services.vscode-server.enable = true;
  # systemd.user.services.auto-fix-vscode-server = true;


  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [ 
    # utils
    bc
    bottom
    ncdu
    eza
    bat
    ripgrep
    fd
    httpie
    jq
    nixd
    awscli2

    # talk
    slack
    discord
    firefox

    vscode

    steam 
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
