{
  home-manager,
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  hostType,
  stylix,
  username,
  ...
}: let
  wallpaper = ../../../wallpapers/deer-sunset.jpg;
in {
  imports = [
    ../../../modules/system
    home-manager.darwinModules.home-manager
  ];

  networking.hostName = "peccy";

  yabai-de.enable = true;
  apps.enable = true;
  desktop.wallpaper = wallpaper;

  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs outputs username wallpaper hostType stylix;};
    users.${username} = import ./home.nix;
  };
}
