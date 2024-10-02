{
  config,
  lib,
  pkgs,
  stylix,
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
