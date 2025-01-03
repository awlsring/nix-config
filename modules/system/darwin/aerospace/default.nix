{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.aerospace = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        Tiling Window Manager for MacOS
      '';
    };
  };

  config = mkIf config.aerospace.enable {
    services.aerospace = {
      enable = true;
      package = pkgs.aerospace;
      settings = {
        mode.main.binding = {
          alt-slash = "layout tiles horizontal vertical";
          alt-comma = "layout accordion horizontal vertical";
          alt-f = "layout floating tiling";
          alt-shift-f = "fullscreen";

          alt-tab = "workspace-back-and-forth";
          alt-m = ["move-node-to-monitor --wrap-around next" "focus-monitor --wrap-around next"];

          alt-minus = "resize smart -50";
          alt-equal = "resize smart +50";

          alt-q = "close --quit-if-last-window";

          alt-left = "focus --boundaries all-monitors-outer-frame left";
          alt-right = "focus --boundaries all-monitors-outer-frame right";

          alt-h = "focus --boundaries all-monitors-outer-frame left";
          alt-j = "focus --boundaries all-monitors-outer-frame down";
          alt-k = "focus --boundaries all-monitors-outer-frame up";
          alt-l = "focus --boundaries all-monitors-outer-frame right";

          alt-shift-left = "move left";
          alt-shift-right = "move right";
          alt-shift-h = "move left";
          alt-shift-j = "move down";
          alt-shift-k = "move up";
          alt-shift-l = "move right";

          ctrl-alt-left = "workspace --wrap-around prev";
          ctrl-alt-right = "workspace --wrap-around next";
          ctrl-alt-1 = "workspace 1";
          ctrl-alt-2 = "workspace 2";
          ctrl-alt-3 = "workspace 3";
          ctrl-alt-4 = "workspace 4";
          ctrl-alt-5 = "workspace 5";
          ctrl-alt-6 = "workspace 6";
          ctrl-alt-7 = "workspace 7";
          ctrl-alt-8 = "workspace 8";
          ctrl-alt-9 = "workspace 9";
          ctrl-alt-0 = "workspace 10";
          ctrl-alt-d = "workspace D";
          ctrl-alt-s = "workspace S";
          ctrl-alt-m = "workspace M";
          ctrl-alt-space = "workspace SMS";

          ctrl-alt-shift-left = ["move-node-to-workspace --wrap-around prev" "workspace --wrap-around prev"];
          ctrl-alt-shift-right = ["move-node-to-workspace --wrap-around next" "workspace --wrap-around next"];
          ctrl-alt-shift-1 = "move-node-to-workspace 1";
          ctrl-alt-shift-2 = "move-node-to-workspace 2";
          ctrl-alt-shift-3 = "move-node-to-workspace 3";
          ctrl-alt-shift-4 = "move-node-to-workspace 4";
          ctrl-alt-shift-5 = "move-node-to-workspace 5";
          ctrl-alt-shift-6 = "move-node-to-workspace 6";
          ctrl-alt-shift-7 = "move-node-to-workspace 7";
          ctrl-alt-shift-8 = "move-node-to-workspace 8";
          ctrl-alt-shift-9 = "move-node-to-workspace 9";
          ctrl-alt-shift-0 = "move-node-to-workspace 10";

          alt-enter = "exec-and-forget open /Applications/Ghostty.app";

          alt-shift-semicolon = "mode service";
        };
        mode.service.binding = {
          esc = ["reload-config" "mode main"];
          r = ["flatten-workspace-tree" "mode main"];
          f = ["layout floating tiling" "mode main"];
          backspace = ["close-all-windows-but-current" "mode main"];

          alt-shift-left = ["join-with left" "mode main"];
          alt-shift-down = ["join-with down" "mode main"];
          alt-shift-up = ["join-with up" "mode main"];
          alt-shift-right = ["join-with right" "mode main"];
          alt-shift-h = ["join-with left" "mode main"];
          alt-shift-j = ["join-with down" "mode main"];
          alt-shift-k = ["join-with up" "mode main"];
          alt-shift-l = ["join-with right" "mode main"];
        };
        on-window-detected = [
          # Floating windows
          {
            "if" = {
              app-id = "org.mozilla.firefox";
              window-title-regex-substring = "Picture-in-Picture";
            };
            run = "layout floating";
          }
          {
            "if".app-id = "com.1password.1password";
            run = "layout floating";
          }
          {
            "if".app-id = "com.apple.finder";
            run = "layout floating";
          }
          {
            "if".app-id = "com.apple.calculator";
            run = "layout floating";
          }
          {
            "if".app-id = "com.apple.systempreferences";
            run = "layout floating";
          }
          # Workspace fixed
          ## DISCORD
          {
            "if".app-id = "com.hnc.Discord";
            run = "move-node-to-workspace D";
          }
          ## SLACK
          {
            "if".app-id = "com.tinyspeck.slackmacgap";
            run = "move-node-to-workspace S";
          }
          ## MUSIC
          {
            "if".app-id = "com.spotify.client";
            run = "move-node-to-workspace M";
          }
          ## Messages
          {
            "if".app-id = "com.apple.MobileSMS";
            run = "move-node-to-workspace SMS";
          }
        ];
        gaps = {
          inner = {
            horizontal = 8;
            vertical = 8;
          };
          outer = {
            left = 8;
            bottom = 8;
            top = 8;
            right = 8;
          };
        };
      };
    };
  };
}
