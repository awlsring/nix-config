{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./waybar.nix
    ./hyprland.nix
  ];
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
}
