{ home-manager, inputs, outputs, lib, config, pkgs, hostType, stylix, username, ...}:
let
 wallpaper = ../../../wallpapers/deer-sunset.jpg;
in
{
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
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs outputs username wallpaper hostType stylix;};
    users.${username} = import ./home.nix;
  };
}


