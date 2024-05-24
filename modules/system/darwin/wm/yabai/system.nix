{ config, pkgs, lib, ... }: 
{
  config = lib.mkIf config."yabai-de".enable {
    system.defaults = {
      dock = {
        autohide = true;
        orientation = "left";
      };
      NSGlobalDomain = {
        _HIHideMenuBar = false;
        AppleKeyboardUIMode = 3;
        "com.apple.keyboard.fnState" = true;
        NSAutomaticWindowAnimationsEnabled = false;
      };
    };
  };
}


  