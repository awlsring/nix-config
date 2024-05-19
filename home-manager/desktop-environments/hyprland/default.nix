{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./waybar.nix
    ./hyprland.nix
    ./stylix.nix
  ];
  home.packages = with pkgs; [
    cinnamon.nemo-with-extensions # file manager
    yazi # terminal file manager
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
