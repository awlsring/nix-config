{
  darwinModules,
  pkgs,
  ...
}: {
  imports = [darwinModules.home];

  tools.enable = true;
  shell = {
    zsh.enable = true;
  };
  dev = {
    email = "contact@matthewrawlings.com";
    pkgs = [
      pkgs.codex
      pkgs.opencode
      pkgs.texlivePackages.latexmk
    ];
  };
  neovim.enable = false;
  tmux.enable = true;

  home.packages = with pkgs; [
    wakeonlan
  ];
}
