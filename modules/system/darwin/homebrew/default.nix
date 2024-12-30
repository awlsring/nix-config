{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./apps.nix
  ];

  options.brew = {
    enable = lib.mkEnableOption "enables homebrew";
    cleanup = lib.mkOption {
      type = lib.types.enum ["zap" "uninstall" "none"];
      default = "zap";
      description = "cleanup homebrew";
    };
  };

  config = lib.mkIf config.brew.enable {
    homebrew = {
      enable = true;
      onActivation = {
        cleanup = config.brew.cleanup;
        autoUpdate = true;
        upgrade = true;
      };
      taps = [
        "homebrew/services"
      ];
      brews = ["git"];
    };
  };
}
