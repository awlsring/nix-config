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
  };

  config = lib.mkIf config.brew.enable {
    homebrew = {
      enable = true;
      onActivation = {
        cleanup = "zap";
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
