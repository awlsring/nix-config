{ home-manager, inputs, outputs, lib, config, pkgs, hostType, stylix, username, ...}:
{
  imports = [
    ../../../modules/home 
  ];

  tools.enable = true;
  zsh.enable = true;
  neovim.enable = true;
  tmux.enable = true;
  lazygit.enable = true;
}


