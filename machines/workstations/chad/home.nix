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
  };
  neovim.enable = true;
  tmux.enable = true;

  home.packages = with pkgs; [
    wakeonlan
  ];

  home.shellAliases = {
    chungus-up = "wakeonlan 00:d8:61:9e:a3:84";
  };
}
