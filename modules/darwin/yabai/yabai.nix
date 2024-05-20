{ config, pkgs, lib, ... }: 
{
  config = lib.mkIf config."yabai-de".enable {
    services.yabai.enable = true;
    services.yabai.package = pkgs.yabai;
    services.yabai.enableScriptingAddition = true;
    services.yabai.extraConfig = ''
      ${builtins.readFile ./config/.yabairc}
    '';
  };
}

