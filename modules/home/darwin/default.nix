inputs: {stylix}: {
  config,
  lib,
  pkgs,
  username,
  ...
}: {
  imports = [
    stylix.homeModules.stylix
    ../common
  ];

  home = {
    username = username;
    homeDirectory = "/Users/${username}";
  };
}
