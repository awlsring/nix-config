{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  home-manager,
  darwinModules,
  wallpapers,
  ...
}: let
  username = "awlsring";
in {
  imports = [
    darwinModules.system
    home-manager.darwinModules.home-manager
  ];

  machine = {
    username = username;
    hostname = "chud";
    class = "desktop";
  };

  brew = {
    enable = true;
    apps = {
      extras = ["godot" "codex" "claude-code" "claude" "codex-app" "notion"];
      masExtras = {
        "Tailscale" = 1475387142;
        "Xcode" = 497799835;
        "Final Cut Pro" = 424389933;
      };
    };
  };

  aerospace.enable = true;

  stylixed = {
    enable = true;
    wallpaper = wallpapers.forest;
  };

  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs outputs username darwinModules;};
    users.${username} = import ./home.nix;
  };
}
