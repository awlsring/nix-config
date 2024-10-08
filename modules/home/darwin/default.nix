inputs: {stylix}: {
  config,
  lib,
  pkgs,
  username,
  ...
}: {
  imports = [
    stylix.homeManagerModules.stylix
    ../common
  ];

  home = {
    username = username;
    homeDirectory = "/Users/${username}";
  };
}
