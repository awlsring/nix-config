{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  home-manager,
  linuxModules,
  wallpapers,
  ...
}: let
  username = "awlsring";
  wallpaper = wallpapers.deer-sunset;
in {
  imports = [
    linuxModules.system
    home-manager.nixosModules.home-manager
    ./hardware-configuration.nix
    # ./bluetooth.nix
    # ./bootloader.nix
    # ./display-manager.nix
    # ./fingerprint.nix
    # ./graphics.nix
    # ./hyprland.nix
    # ./location.nix
    # ./nix.nix
    # ./screen.nix
    # ./services.nix
    # ./sounds.nix
    # ./swap.nix
    # ./terminal.nix
    ./theme.nix
    # ./time.nix
    # ./user.nix
    # ./virtualization.nix
    # ./zen-kernel.nix
  ];

  machine = {
    username = username;
    hostname = "ched";
    class = "laptop";
  };

  environments.hyprland.enable = true;

  stylixed = {
    enable = false;
    wallpaper = wallpaper;
  };

  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs outputs username linuxModules wallpaper;};
    users.${username} = import ./home.nix;
    backupFileExtension = "hm-bak";
  };
}
