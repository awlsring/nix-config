{
  pkgs,
  config,
  lib,
  ...
}: {
  options.shell.zsh = {
    enable = lib.mkEnableOption "enables zsh";
    aliases = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "Shell aliases.";
    };
    initExtra = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Extra commands to run on shell init.";
    };
  };

  config = lib.mkIf config.shell.zsh.enable {
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      historySubstringSearch.enable = true;
      dotDir = ".config/zsh";
      shellAliases = lib.mkMerge [
        {
          ls = "${pkgs.eza}/bin/eza --icons -a --group-directories-first";
          tree = "${pkgs.eza}/bin/eza --color=auto --tree";
          cal = "cal -m";
          grep = "grep --color=auto";
          q = "exit";
          ":q" = "exit";
          mkdir = "mkdir -p";
          kb = "${pkgs.kubectl}/bin/kubectl";
          kba = "${pkgs.kubectl}/bin/kubectl apply -f";
          kbd = "${pkgs.kubectl}/bin/kubectl delete -f";
          kbg = "${pkgs.kubectl}/bin/kubectl get all";
          cat = "${pkgs.bat}/bin/bat -p";
        }
        config.shell.zsh.aliases
      ];

      initExtra = ''
        # Run fastfetch cause its cool
        ${pkgs.fastfetch}/bin/fastfetch

        # kitty only alias
        if [[ -n "$KITTY_PID" ]]; then
          alias imgcat="kitty +kitten icat"
          alias ssh="kitty +kitten ssh $@"
          alias ssh-compat="TERM=xterm-256color \ssh"
        fi

        # Extra commands
        ${config.shell.zsh.initExtra}
      '';
    };
  };
}
