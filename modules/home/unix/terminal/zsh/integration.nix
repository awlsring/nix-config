{
  pkgs,
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.zsh.enable {
    programs.yazi = {
      enable = true;
      package = pkgs.yazi;
      enableZshIntegration = true;
    };

    programs.starship = {
      enable = true;
      package = pkgs.starship;
      enableZshIntegration = true;
      settings = {
        hostname.style = "bold green";
        aws.disabled = true;
        # OS Symbol on prompt end
        custom.system_icons = {
          command = "([ $(uname -s) == 'Darwin' ] && echo ) || ([ $(uname -s) == 'Linux' ] && echo )";
          symbol = "|";
          format = "[$symbol]() [$output]($style) ";
          style = "bold";
          shell = ["bash" "--noprofile" "--norc"];
          when = "true";
        };
        # Add python when in venv
        custom.pythonenv = {
          command = "pv=$(python --version | grep -Eo \"\\d+\\.\\d+\"); echo \"🐍 $pv\";";
          style = "blue";
          when = "[[ -n \"$VIRTUAL_ENV\" || $PATH =~ /pyenv/ ]]";
          shell = ["bash" "--noprofile" "--norc"];
        };
      };
    };

    programs.eza = {
      enable = true;
      package = pkgs.eza;
      enableZshIntegration = true;
    };

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
