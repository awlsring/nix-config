{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # ./lsp.nix
    # ./syntax.nix
    # ./ui.nix
  ];

  # programs.nixvim = {
  #   enable = true;
  #   colorschemes.gruvbox.enable = true;
  #   plugins.lightline.enable = true;
  # };


  # home.sessionVariables.EDITOR = "nvim";

  # xdg.configFile.nvim.source = ./config;

  # programs.neovim = {
  #   enable = true;
  #   withNodeJs = true;
  #   withPython3 = true;
  #   viAlias = true;
  #   vimAlias = true;
  #   # extraConfig = 
  #   # ''
  #   #   set expandtab
  #   # '';
  #   # plugins = with pkgs.vimPlugins; [
  #   #   telescope-nvim
  #   #   # telescope-recent-files
  #   # ];
  # };
}