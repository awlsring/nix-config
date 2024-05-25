{ inputs, outputs, lib, config, pkgs, wallpaper, ...}:
{
  imports = [
    ../../../modules/home 
  ];

  tools.enable = true;
  zsh.enable = true;
  neovim.enable = true;
  lazygit.enable = true;
}


