{
  config,
  lib,
  pkgs,
  outputs,
  hostType,
  username,
  stylix,
  ...
}: {
  imports = [
    ./unix
    (
      if hostType == "nixos"
      then ./linux
      else if hostType == "darwin"
      then ./darwin
      else {}
    )
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.stable
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  nix = {
    package = pkgs.nix;
    settings = {
      "extra-experimental-features" = ["nix-command" "flakes"];
    };
  };

  environment = {
    shells = with pkgs; [zsh];
    systemPackages = with pkgs; [
      git
    ];
  };

  fonts = {
    packages = with pkgs; [
      atkinson-hyperlegible
      jetbrains-mono
    ];
  };

  programs = {
    zsh.enable = true;
  };

  # services.tailscale.enable = true;

  # This doesn't work if null???
  stylix = lib.mkIf (config.desktop.wallpaper != null) {
    image = config.desktop.wallpaper;
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
}
