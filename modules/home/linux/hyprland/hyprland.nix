{
  config,
  pkgs,
  lib,
  inputs,
  wallpaper,
  ...
}: let
  startScript = pkgs.writeShellScriptBin "start" ''
    ${pkgs.swww}/bin/swww init &

    ${pkgs.networkmanagerapplet}/bin/nm-applet --indicator &

    hyprctl setcursor Bibata-Modern-Ice 16 &

    systemctl --user import-environment PATH &
    systemctl --user restart xdg-desktop-portal.service &

    # wait a tiny bit for wallpaper
    sleep 2

    ${pkgs.swww}/bin/swww img ${wallpaper} --transition-type simple
  '';
in {
  config = lib.mkIf config.hyprland.enable {
    # Notifications
    services.mako = {
      enable = true;
      defaultTimeout = 10000;
      layer = "overlay";
    };

    # Hyprpaper
    # services.hyprpaper = {
    #   enable = true;
    #   settings = {
    #     preload = "/home/awlsring/nix-config/home-manager/desktop-environments/hyprland/wallpapers/deer-sunset.jpg"; # Make this suck less
    #     wallpaper = "monitor,/home/awlsring/nix-config/home-manager/desktop-environments/hyprland/wallpapers/deer-sunset.jpg";
    #     splash = true;
    #   };
    # };

    # Hyprland Configuration
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        monitor = [
          "HDMI-A-1,3440x1440,0x0,1"
          "DP-1,2560x1440,3440x-400,1,transform,3"
        ];
        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;

          layout = "master";
        };
        input = {
          kb_layout = "us";
          kb_variant = "";
          kb_model = "";

          kb_options = [
            "ctrl:nocaps"
          ];

          follow_mouse = 1;

          touchpad = {
            natural_scroll = false;
          };

          repeat_rate = 40;
          repeat_delay = 250;
          force_no_accel = true;

          sensitivity = 0.0; # -1.0 - 1.0, 0 means no modification.
        };

        animations.enabled = true;

        # Window rules
        windowrule = [
          # Float rules
          "float,^(pavucontrol)$" # Audio control
          "float,^(nm-connection-editor)$" # Network Manager
          "float,^(1Password)$" # 1Password
        ];

        "$mainMod" = "ALT";

        # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
        bind =
          [
            "$mainMod, return, exec, kitty"
            "$mainMod, Q, killactive,"
            "$mainMod SHIFT, M, exit,"
            "$mainMod SHIFT, F, togglefloating,"
            "$mainMod, F, fullscreen,"
            "$mainMod, G, togglegroup,"
            "$mainMod, bracketleft, changegroupactive, b"
            "$mainMod, bracketright, changegroupactive, f"
            "$mainMod, SPACE, exec, wofi --show drun --allow-images"
            "$mainMod, P, pin, active"

            "$mainMod, h, movefocus, l"
            "$mainMod, l, movefocus, r"
            "$mainMod, k, movefocus, u"
            "$mainMod, j, movefocus, d"

            "$mainMod SHIFT, h, movewindow, l"
            "$mainMod SHIFT, l, movewindow, r"
            "$mainMod SHIFT, k, movewindow, u"
            "$mainMod SHIFT, j, movewindow, d"

            # Orientation
            "$mainMod, up, layoutmsg, orientationtop"
            "$mainMod, down, layoutmsg, orientationbottom"
            "$mainMod, left, layoutmsg, orientationleft"
            "$mainMod, right, layoutmsg, orientationright"

            # Scroll through existing workspaces with mainMod + scroll
            "bind = $mainMod, mouse_down, workspace, e+1"
            "bind = $mainMod, mouse_up, workspace, e-1"

            # Audio controls
            ## PulseAudio
            # ", XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
            # ", XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
            ## PipeWire
            ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
            ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ]
          ++ map (n: "$mainMod SHIFT, ${toString n}, movetoworkspace, ${toString (
            if n == 0
            then 10
            else n
          )}") [1 2 3 4 5 6 7 8 9 0]
          ++ map (n: "$mainMod, ${toString n}, workspace, ${toString (
            if n == 0
            then 10
            else n
          )}") [1 2 3 4 5 6 7 8 9 0];

        binde = [
          "$mainMod SHIFT, h, moveactive, -20 0"
          "$mainMod SHIFT, l, moveactive, 20 0"
          "$mainMod SHIFT, k, moveactive, 0 -20"
          "$mainMod SHIFT, j, moveactive, 0 20"

          "$mainMod CTRL, l, resizeactive, 30 0"
          "$mainMod CTRL, h, resizeactive, -30 0"
          "$mainMod CTRL, k, resizeactive, 0 -10"
          "$mainMod CTRL, j, resizeactive, 0 10"
        ];

        bindm = [
          # Move/resize windows with mainMod + LMB/RMB and dragging
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        exec-once = [
          "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
          "${pkgs.bash}/bin/bash ${startScript}/bin/start"

          # Set the wallpaper
          (
            if wallpaper != null
            then "swww img ${wallpaper}"
            else ""
          )

          "waybar"
        ];
      };
    };
  };
}
