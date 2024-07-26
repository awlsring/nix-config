{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf config."yabai-de".enable {
    # Brew packages
    homebrew = {
      casks = [
        "sf-symbols"
        "alfred"
      ];
    };
  };
}
