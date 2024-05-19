{
  config,
  pkgs,
  lib,
  inputs,
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
  '';
  custom = {
    font = "JetBrainsMono Nerd Font";
    font_size = "15px";
    font_weight = "bold";
    text_color = "#cdd6f4";
    secondary_accent = "89b4fa";
    tertiary_accent = "f5f5f5";
    background = "11111B";
    opacity = "0.98";
  };
in {
  home.packages = with pkgs; [
    grim
    slurp
    wl-clipboard
    eww
    rofi-wayland
    wofi
    swww
    libnotify
    networkmanagerapplet
    pavucontrol
    pamixer
  ];

  services.mako = {
    enable = true;
    backgroundColor = "#${config.colorScheme.colors.base01}";
    borderColor = "#${config.colorScheme.colors.base0E}";
    borderRadius = 5;
    borderSize = 2;
    textColor = "#${config.colorScheme.colors.base04}";
    defaultTimeout = 10000;
    layer = "overlay";
  };

  # Waybar Configuration
  programs.waybar.enable = true;
  programs.waybar.package = pkgs.waybar.overrideAttrs (oa: {
    mesonFlags = (oa.mesonFlags or []) ++ ["-Dexperimental=true"];
  });
  programs.waybar.style = ''

    * {
        border: none;
        border-radius: 0px;
        padding: 0;
        margin: 0;
        min-height: 0px;
        font-family: ${custom.font};
        font-weight: ${custom.font_weight};
        opacity: ${custom.opacity};
    }

    window#waybar {
        background: none;
    }

    #workspaces {
        font-size: 18px;
        padding-left: 15px;

    }
    #workspaces button {
        color: ${custom.text_color};
        padding-left:  6px;
        padding-right: 6px;
    }
    #workspaces button.empty {
        color: #6c7086;
    }
    #workspaces button.active {
        color: #b4befe;
    }

    #tray, #pulseaudio, #network, #cpu, #memory, #disk, #clock, #battery {
        font-size: ${custom.font_size};
        color: ${custom.text_color};
    }

    #cpu {
        padding-left: 15px;
        padding-right: 9px;
        margin-left: 7px;
    }
    #memory {
        padding-left: 9px;
        padding-right: 9px;
    }
    #disk {
        padding-left: 9px;
        padding-right: 15px;
    }

    #tray {
        padding: 0 20px;
        margin-left: 7px;
    }

    #pulseaudio {
        padding-left: 15px;
        padding-right: 9px;
        margin-left: 7px;
    }
    #battery {
        padding-left: 9px;
        padding-right: 9px;
    }
    #network {
        padding-left: 9px;
        padding-right: 15px;
    }

    #clock {
        padding-left: 9px;
        padding-right: 15px;
    }

    #custom-launcher {
        font-size: 20px;
        color: #b4befe;
        font-weight: ${custom.font_weight};
        padding-left: 10px;
        padding-right: 15px;
    }
  '';
  programs.waybar.settings.mainBar = {
    position = "top";
    layer = "top";
    height = 5;
    margin-top = 0;
    margin-bottom = 0;
    margin-left = 0;
    margin-right = 0;
    modules-left = [
      "custom/launcher"
      "hyprland/workspaces"
    ];
    modules-center = [
      "clock"
    ];
    modules-right = [
      "tray"
      "cpu"
      "memory"
      "disk"
      "pulseaudio"
      "battery"
      "network"
    ];
    clock = {
      calendar = {
        format = {today = "<span color='#b4befe'><b><u>{}</u></b></span>";};
      };
      format = " {:%H:%M}";
      tooltip = "true";
      tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      format-alt = " {:%d/%m}";
    };
    "hyprland/workspaces" = {
      active-only = false;
      disable-scroll = true;
      format = "{icon}";
      on-click = "activate";
      format-icons = {
        "1" = "󰈹";
        "2" = "";
        "3" = "󰘙";
        "4" = "󰙯";
        "5" = "";
        "6" = "";
        urgent = "";
        default = "";
        sort-by-number = true;
      };
      persistent-workspaces = {
        "1" = [];
        "2" = [];
        "3" = [];
        "4" = [];
        "5" = [];
      };
    };
    memory = {
      format = "󰟜 {}%";
      format-alt = "󰟜 {used} GiB"; # 
      interval = 2;
    };
    cpu = {
      format = "  {usage}%";
      format-alt = "  {avg_frequency} GHz";
      interval = 2;
    };
    disk = {
      # path = "/";
      format = "󰋊 {percentage_used}%";
      interval = 60;
    };
    network = {
      format-wifi = "  {signalStrength}%";
      format-ethernet = "󰀂 ";
      tooltip-format = "Connected to {essid} {ifname} via {gwaddr}";
      format-linked = "{ifname} (No IP)";
      format-disconnected = "󰖪 ";
    };
    tray = {
      icon-size = 20;
      spacing = 8;
    };
    pulseaudio = {
      format = "{icon} {volume}%";
      format-muted = "󰖁  {volume}%";
      format-icons = {
        default = [" "];
      };
      scroll-step = 5;
      on-click = "pavucontrol";
    };
    battery = {
      format = "{icon} {capacity}%";
      format-icons = [" " " " " " " " " "];
      format-charging = " {capacity}%";
      format-full = " {capacity}%";
      format-warning = " {capacity}%";
      interval = 5;
      states = {
        warning = 20;
      };
      format-time = "{H}h{M}m";
      tooltip = true;
      tooltip-format = "{time}";
    };
    "custom/launcher" = {
      format = "";
      on-click = "pkill wofi || wofi --show drun";
      on-click-right = "pkill wofi || wallpaper-picker";
      tooltip = "false";
    };
  };

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
        "col.active_border" = "rgba(${config.colorScheme.colors.base0E}ff) rgba(${config.colorScheme.colors.base09}ff) 60deg";
        "col.inactive_border" = "rgba(${config.colorScheme.colors.base00}ff)";

        layout = "master";
      };
      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";

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

      windowrule = [
        "float,^(pavucontrol)$"
        "float,^(pavucontrol)$"
        "float,^(nm-connection-editor)$"
      ];

      "$mainMod" = "SUPER";

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
          "$mainMod, O, exec, wofi --show drun"
          "$mainMod, S, exec, rofi -show drun -show-icons"
          "$mainMod, P, pin, active"

          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"

          "$mainMod, h, movefocus, l"
          "$mainMod, l, movefocus, r"
          "$mainMod, k, movefocus, u"
          "$mainMod, j, movefocus, d"

          "$mainMod SHIFT, h, movewindow, l"
          "$mainMod SHIFT, l, movewindow, r"
          "$mainMod SHIFT, k, movewindow, u"
          "$mainMod SHIFT, j, movewindow, d"

          "$mainMod, Y, layoutmsg, orientationtop"

          # Scroll through existing workspaces with mainMod + scroll
          "bind = $mainMod, mouse_down, workspace, e+1"
          "bind = $mainMod, mouse_up, workspace, e-1"
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
        "waybar"
      ];
    };
  };
}
