{darwinModules, ...}: {
  imports = [darwinModules.home];

  tools.enable = true;
  shell = {
    zsh.enable = true;
    kitty.enable = true;
  };
  dev = {
    email = "contact@matthewrawlings.com";
  };
  neovim.enable = true;
  tmux.enable = true;
}
