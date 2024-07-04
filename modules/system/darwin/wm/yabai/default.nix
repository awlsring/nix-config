{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./yabai.nix
    ./skhd.nix
    ./sketchybar.nix
    ./packages.nix
    ./system.nix
  ];
  options = {
    "yabai-de" = {
      enable = lib.mkEnableOption "enables yabai desktop environment";
    };
  };

  config = lib.mkIf config."yabai-de".enable {
    fonts.packages = with pkgs; [
      sketchybar-app-font
      font-awesome
    ];
  };
}
