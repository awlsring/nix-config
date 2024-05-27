{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./waybar.nix
    ./hyprland.nix
  ];

  options.hyprland = {
    enable = lib.mkEnableOption "enables hyprland wm";
  };

  config = lib.mkIf config.hyprland.enable {
    home.packages = with pkgs; [
      cinnamon.nemo-with-extensions # file manager
      qalculate-gtk # calculator
      grim
      slurp
      wl-clipboard
      eww
      rofi-wayland
      wofi
      swww
      libnotify
      networkmanagerapplet
      pavucontrol
      pamixer
    ];
  };
}
