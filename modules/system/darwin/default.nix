{
  config,
  lib,
  pkgs,
  stylix,
  ...
}: {
  imports = [
    ./homebrew
    ./stylixed
    ./system
    ./yabai
    ../common
    stylix.darwinModules.stylix
    # sops-nix.darwinModules.sops # not officially supported, one a dev branch https://github.com/truelecter/sops-nix/blob/darwin-upstream/modules/darwin/default.nix
  ];
}
