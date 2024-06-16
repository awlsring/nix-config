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
  wallpaper = ../../../wallpapers/shaded_landscape.jpg;
in {
  imports = [
    ../../../modules/system
    home-manager.darwinModules.home-manager
  ];

  networking.hostName = "chad";

  yabai-de.enable = true;
  tailscale.enable = true;
  apps.enable = true;
  desktop.wallpaper = wallpaper;

  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs outputs username wallpaper hostType stylix;};
    users.${username} = import ./home.nix;
  };
}
