{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./zsh
    ./fastfetch
    ./starship
  ];
}
