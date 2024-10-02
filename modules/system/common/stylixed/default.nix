{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    stylixed = {
      enable = lib.mkEnableOption "enables stylix";
      wallpaper = lib.mkOption {
        type = lib.types.path;
        description = "Path to the wallpaper image";
      };
    };
  };

  config = lib.mkIf config.stylixed.enable {
    assertions = [
      {
        assertion = config.stylixed.wallpaper != null;
        message = "The option `stylixed.wallpaper` must be set when `stylixed.enable` is true.";
      }
    ];

    stylix = {
      enable = true;
      image = config.stylixed.wallpaper;
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
      homeManagerIntegration.autoImport = false;
    };
  };
}
