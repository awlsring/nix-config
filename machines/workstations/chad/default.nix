{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  stylix,
  home-manager,
  darwinModules,
  ...
}: let
  username = "awlsring";
  wallpaper = ../../../wallpapers/shaded_landscape.jpg;
in {
  imports = [
    darwinModules.system
    home-manager.darwinModules.home-manager
  ];

  machine = {
    username = username;
    hostname = "chad";
  };

  brew = {
    enable = true;
    apps = {
      extras = ["godot"];
      masExtras = {
        "Tailscale" = 1475387142;
        "Xcode" = 497799835;
        "Final Cut Pro" = 424389933;
      };
    };
  };

  yabai-de.enable = true;

  stylixed = {
    enable = true;
    wallpaper = wallpaper;
  };

  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs outputs username darwinModules;};
    users.${username} = import ./home.nix;
  };
}
