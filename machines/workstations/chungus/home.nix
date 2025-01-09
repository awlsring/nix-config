{
  linuxModules,
  wallpaper,
  ...
}: {
  imports = [linuxModules.home];

  dev.email = "contact@matthewrawlings.com";

  # linux modules
  apps.enable = true;
  gaming.enable = true;
  hyprland.enable = true;

  # unix modules
  tools.enable = true;
  shell.zsh.enable = true;
  terminal.ghostty.enable = true;
  neovim.enable = true;
  tmux.enable = true;
}
