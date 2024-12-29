{
  config,
  lib,
  pkgs,
  ...
}: {
  options.tools = {
    enable = lib.mkEnableOption "enables tools";
    extra = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "List of extra tools to install";
    };
  };

  config = lib.mkIf config.tools.enable {
    programs = {
      bat = {
        enable = true;
        extraPackages = with pkgs.bat-extras; [batman];
      };
      bottom = {
        enable = true;
        package = pkgs.bottom;
      };
      direnv = {
        enable = true;
        package = pkgs.direnv;
        enableZshIntegration = config.shell.zsh.enable;
        nix-direnv = {
          enable = true;
          package = pkgs.nix-direnv;
        };
      };
      lazygit = {
        enable = true;
        package = pkgs.lazygit;
      };
      yazi = {
        enable = true;
        package = pkgs.yazi;
        enableZshIntegration = true;
      };
      eza = {
        enable = true;
        package = pkgs.eza;
        enableZshIntegration = true;
      };
      zoxide = {
        enable = true;
        enableZshIntegration = true;
      };
      git.enable = true;
      gpg.enable = true;
    };

    home.packages = with pkgs;
      [
        bc
        ripgrep
        fd
        httpie
        jq
        awscli
        _1password-cli
        alejandra
        tmux
        sops
        gh
        fzf
        glow
        kubectl
        k9s
      ]
      ++ config.tools.extra;
  };
}
