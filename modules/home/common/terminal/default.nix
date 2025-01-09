{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./kitty
    ./ghostty
  ];
}
