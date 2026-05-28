{
  darwinModules,
  pkgs,
  ...
}: let
  tailscaleCli = pkgs.writeShellScriptBin "tailscale" ''
    export TAILSCALE_BE_CLI=1
    exec /Applications/Tailscale.app/Contents/MacOS/Tailscale "$@"
  '';
in {
  imports = [darwinModules.home];

  tools.enable = true;
  shell = {
    zsh.enable = true;
  };
  dev = {
    email = "contact@matthewrawlings.com";
  };
  neovim.enable = false;
  tmux.enable = true;

  home.packages = with pkgs; [
    tailscaleCli
    wakeonlan
  ];
}
