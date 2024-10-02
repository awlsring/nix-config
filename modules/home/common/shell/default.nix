{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./zsh
    ./fastfetch
    ./kitty
    ./starship
  ];
}
