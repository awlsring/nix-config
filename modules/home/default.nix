{ 
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  hostType,
  stylix,
  ... 
}: {
  imports = [
    stylix.homeManagerModules.stylix
    ./unix
    ./dev
    ( 
      if hostType == "nixos" || hostType == "linux" then ./linux 
      else if hostType == "darwin" then ./darwin
      else throw "Unsupported host type: ${hostType}"
    )
  ];

  # Stylix config
  stylix = {
    image = ../../wallpapers/deer-sunset.jpg;
    polarity = "dark";
    fonts = {
      monospace = {
        package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
    };
  };

  # Enable home-manager
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}