{ home-manager, inputs, outputs, lib, config, pkgs, hostType, stylix, username, ...}:
{
  imports = [
    ../../../modules/system 
    home-manager.darwinModules.home-manager
  ];

  networking.hostName = "chad";

  yabai-de.enable = true;
  tailscale.enable = true;
  apps.enable = true;
  desktop.wallpaper = ../../../wallpapers/deer-sunset.jpg;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs outputs username hostType stylix;};
    users.${username} = import ./home.nix;
  };
}


