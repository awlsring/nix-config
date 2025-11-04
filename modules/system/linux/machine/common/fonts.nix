{ ... }:

{
  # System Fonts
  fonts = {
    fontDir.enable = true;
    fontconfig = {
      defaultFonts = {
        monospace = ["JetBrainsMono Nerd Font Mono"];
        sansSerif = ["JetBrainsMono Nerd Font Mono"];
        serif = ["JetBrainsMono Nerd Font Mono"];
      };
    };
  };
}