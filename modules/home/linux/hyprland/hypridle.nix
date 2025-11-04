{...}:{
  services.hypridle = {
    enable = true;

    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 150;
          on-timeout = "brightnessctl set 0 --save && brightnessctl --device=tpacpi::kbd_backlight set 0 --save";
          on-resume = "brightnessctl --restore && brightnessctl --device=tpacpi::kbd_backlight --restore";
        }
        {
          timeout = 300;
          "on-timeout" = "pidof hyprlock || hyprlock";
        }
        {
          timeout = 380;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 600;
          "on-timeout" = "systemctl suspend";
        }
      ];
    };
  };
}