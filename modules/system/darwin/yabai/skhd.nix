{
  config,
  pkgs,
  lib,
  ...
}: {
  options."yabai-de".skhd = {
    super = lib.mkOption {
      description = "Super key";
      type = lib.types.str;
      default = "alt";
    };
  };

  config = lib.mkIf config."yabai-de".enable (let
    super = config."yabai-de".skhd.super;
  in {
    services.skhd = {
      enable = true;
      package = pkgs.skhd;
      skhdConfig = ''
        # opens terminal
        ${super} - return : open -a kitty

        # Navigation
        ${super} - h : yabai -m window --focus west
        ${super} - j : yabai -m window --focus south
        ${super} - k : yabai -m window --focus north
        ${super} - l : yabai -m window --focus east

        # create space

        # Moving windows
        shift + ${super} - h : yabai -m window --warp west
        shift + ${super} - j : yabai -m window --warp south
        shift + ${super} - k : yabai -m window --warp north
        shift + ${super} - l : yabai -m window --warp east

        # Move focus container to workspace
        shift + ${super} - m : yabai -m window --space last; yabai -m space --focus last
        shift + ${super} - p : yabai -m window --space prev; yabai -m space --focus prev
        shift + ${super} - n : yabai -m window --space next; yabai -m space --focus next
        shift + ${super} - 1 : yabai -m window --space 1; yabai -m space --focus 1
        shift + ${super} - 2 : yabai -m window --space 2; yabai -m space --focus 2
        shift + ${super} - 3 : yabai -m window --space 3; yabai -m space --focus 3
        shift + ${super} - 4 : yabai -m window --space 4; yabai -m space --focus 4

        # Resize windows
        lctrl + ${super} - h : yabai -m window --resize left:-20:0; \
                          yabai -m window --resize right:-20:0
        lctrl + ${super} - j : yabai -m window --resize bottom:0:20; \
                          yabai -m window --resize top:0:20
        lctrl + ${super} - k : yabai -m window --resize top:0:-20; \
                          yabai -m window --resize bottom:0:-20
        lctrl + ${super} - l : yabai -m window --resize right:20:0; \
                          yabai -m window --resize left:20:0

        # Equalize size of windows
        lctrl + ${super} - e : yabai -m space --balance

        # Enable / Disable gaps in current workspace
        lctrl + ${super} - g : yabai -m space --toggle padding; yabai -m space --toggle gap

        # Rotate windows clockwise and anticlockwise
        ${super} - r         : yabai -m space --rotate 270
        shift + ${super} - r : yabai -m space --rotate 90

        # Rotate on X and Y Axis
        shift + ${super} - x : yabai -m space --mirror x-axis
        shift + ${super} - y : yabai -m space --mirror y-axis

        # Set insertion point for focused container
        shift + lctrl + ${super} - h : yabai -m window --insert west
        shift + lctrl + ${super} - j : yabai -m window --insert south
        shift + lctrl + ${super} - k : yabai -m window --insert north
        shift + lctrl + ${super} - l : yabai -m window --insert east

        # Float / Unfloat window
        shift + ${super} - space : \
            yabai -m window --toggle float; \
            yabai -m window --toggle border

        # Make window native fullscreen
        ${super} - f         : yabai -m window --toggle zoom-fullscreen
        shift + ${super} - f : yabai -m window --toggle native-fullscreen
      '';
    };
  });
}
