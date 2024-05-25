{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [
    ./fastfetch.nix
    ./integration.nix
    ./terminal.nix
  ];

  options.zsh = {
    enable = lib.mkEnableOption "enables zsh terminal";
  };

  config = lib.mkIf config.zsh.enable {
    home.packages = with pkgs; [
      zsh-powerlevel10k
    ];

    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      historySubstringSearch.enable = true;
      dotDir = ".config/zsh";
      shellAliases = {
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
        cat = "${pkgs.bat}/bin/bat";
      };
      initExtra = ''
        # Load theme
        ${builtins.readFile ./themes/p10k.zsh}

        # Run fastfetch cause its cool
        ${pkgs.fastfetch}/bin/fastfetch
      '';
      zplug = {
        enable = true;
        plugins = [
          { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
        ];
      };
    };
  };
}
