inputs: {stylix}: {...}: {
  imports = [
    ./homebrew
    ./stylixed
    ./machine
    ./yabai
    ./aerospace
    ../common
    stylix.darwinModules.stylix
    # sops-nix.darwinModules.sops # not officially supported, one a dev branch https://github.com/truelecter/sops-nix/blob/darwin-upstream/modules/darwin/default.nix
  ];
}
