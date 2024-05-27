{
  config,
  lib,
  pkgs,
  ...
}: {
  options.tmux = {
    enable = lib.mkEnableOption "enables tmux";
  };

  config = lib.mkIf config.tmux.enable {
    programs.tmux = {
      enable = true;
      package = pkgs.tmux;
      mouse = true;
      clock24 = true;
      keyMode = "vi";
      sensibleOnTop = false;
      tmuxinator.enable = true;
      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = vim-tmux-navigator;
          extraConfig = ''
            # From https://github.com/christoomey/vim-tmux-navigator?tab=readme-ov-file#tmux
            is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
                | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf)(diff)?$'"
            bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
            bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
            bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
            bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
            tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
            if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
                "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
            if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
                "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

            bind-key -T copy-mode-vi 'C-h' select-pane -L
            bind-key -T copy-mode-vi 'C-j' select-pane -D
            bind-key -T copy-mode-vi 'C-k' select-pane -U
            bind-key -T copy-mode-vi 'C-l' select-pane -R
            bind-key -T copy-mode-vi 'C-\' select-pane -l
          '';
        }
      ];
      extraConfig = ''
        unbind r
        bind r source-file ~/.config/tmux/tmux.conf \; display-message "Reloaded tmux.conf"

        set -g prefix C-s
        set -sg escape-time 1

        set-option -g status-position top

        bind-key h select-pane -L
        bind-key j select-pane -D
        bind-key k select-pane -U
        bind-key l select-pane -R

        unbind [
        unbind ]
        bind-key [ split-window -v
        bind-key ] split-window -h
      '';
    };
  };
}
