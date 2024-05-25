{ inputs, outputs, lib, config, pkgs, ...}:
{
  imports = [
    ../../../modules/home 
  ];

  tools.enable = true;
  zsh.enable = true;
  neovim.enable = true;
}


