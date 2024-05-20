{ config, pkgs, lib, ... }: 
{
  options = {
    "yabai-de".skhd = {

    };
  };

  config = lib.mkIf config."yabai-de".enable {
    services.skhd = {
      enable = true;
      package = pkgs.skhd;
      skhdConfig = builtins.readFile ./config/.skhdrc;
    };
  };
}