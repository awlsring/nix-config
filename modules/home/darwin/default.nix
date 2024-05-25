{ config, lib, pkgs, username, ... }: {
  home = {
    username = username;
    homeDirectory = "/Users/${username}";
  };
}