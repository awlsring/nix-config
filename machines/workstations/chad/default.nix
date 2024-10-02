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

  networking.hostName = "chad";

  system = {
    enable = true;
    username = username;
  };
  brew = {
    enable = true;
    apps.extras = ["godot"];
  };
  yabai-de.enable = true;
  stylixed = {
    enable = true;
    wallpaper = wallpaper;
  };

  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs outputs username stylix darwinModules;};
    users.${username} = import ./home.nix;
  };
}
