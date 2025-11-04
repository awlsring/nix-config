# Common settings
{
  config,
  lib,
  pkgs,
  outputs,
  ...
}: {
  imports = [
    ./stylixed
    ./machine
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
}
