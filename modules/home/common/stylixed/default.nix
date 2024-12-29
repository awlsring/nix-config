{
  config,
  lib,
  pkgs,
  ...
}: {
  options.stylixed = {
    enable = lib.mkEnableOption "enables stylixed";
    wallpaper = lib.mkOption {
      type = lib.types.path;
      description = "Path to the wallpaper image";
    };
  };

  config = lib.mkIf config.stylixed.enable {
    stylix = {
      enable = true;
      image = config.stylixed.wallpaper;
      polarity = "dark";
      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
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
  };
}
