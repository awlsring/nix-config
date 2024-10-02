{
  pkgs,
  config,
  lib,
  ...
}: {
  options.shell.starship.disable = lib.mkEnableOption "enables starship";

  config = lib.mkIf (!config.shell.starship.disable) {
    programs.starship = {
      enable = true;
      package = pkgs.starship;
      enableZshIntegration = config.shell.zsh.enable;
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
  };
}
