{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf config."yabai-de".enable {
    services.yabai.enable = true;
    services.yabai.package = pkgs.yabai;
    services.yabai.enableScriptingAddition = true;
    services.yabai.extraConfig = ''
      #!/usr/bin/env bash

      set -x

      # ====== Variables =============================

      declare -A gaps
      declare -A color

      gaps["top"]="6"
      gaps["bottom"]="20"
      gaps["left"]="6"
      gaps["right"]="6"
      gaps["inner"]="6"

      color["focused"]="0xE0808080"
      color["normal"]="0x00010101"
      color["preselect"]="0xE02d74da"

      # Enable Scripting

      # See: https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(latest-release)#macos-big-sur---automatically-load-scripting-addition-on-startup
      sudo yabai --load-sa
      yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"

      # Tiling setting

      yabai -m config layout                      bsp

      yabai -m config top_padding                 6
      yabai -m config bottom_padding              20
      yabai -m config left_padding                6
      yabai -m config right_padding               6
      yabai -m config window_gap                  6

      yabai -m config mouse_follows_focus         no
      yabai -m config focus_follows_mouse         yes

      yabai -m config window_topmost              off
      yabai -m config window_opacity              on
      yabai -m config window_shadow               float

      yabai -m config window_border               on
      yabai -m config window_border_width         2
      yabai -m config active_window_border_color  "0xE0808080"
      yabai -m config normal_window_border_color  "0x00010101"
      yabai -m config insert_feedback_color       "0xE02d74da"

      yabai -m config active_window_opacity       1.0
      yabai -m config normal_window_opacity       0.95
      yabai -m config split_ratio                 0.50

      yabai -m config auto_balance                off

      yabai -m config mouse_modifier              fn
      yabai -m config mouse_action1               move
      yabai -m config mouse_action2               resize

      # ===== Rules ==================================
      yabai -m rule --add label="Alfred Preferences" app="^Alfred Preferences$" title=".*" manage=off
      yabai -m rule --add label="System Settings" app="^System Settings$" title=".*" manage=off
      yabai -m rule --add label="Finder" app="^Finder$" title=".*" manage=off
      yabai -m rule --add label="App Store" app="^App Store$" manage=off
      yabai -m rule --add label="Activity Monitor" app="^Activity Monitor$" manage=off
      yabai -m rule --add label="1Password" app="^1Password$" manage=off
      yabai -m rule --add label="Calculator" app="^Calculator$" manage=off
      yabai -m rule --add label="Dictionary" app="^Dictionary$" manage=off
      yabai -m rule --add label="Software Update" title="Software Update" manage=off
      yabai -m rule --add label="Messages" app="^Messages$" title=".*" manage=off
      yabai -m rule --add label="About This Mac" app="System Information" title="About This Mac" manage=off

      set +x
      printf "yabai: configuration loaded...\\n"
    '';
  };
}
