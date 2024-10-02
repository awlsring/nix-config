{darwinModules, ...}: {
  imports = [darwinModules.home];

  tools.enable = true;
  shell = {
    zsh.enable = true;
    kitty.enable = true;
  };
  neovim.enable = true;
  tmux.enable = true;
}
