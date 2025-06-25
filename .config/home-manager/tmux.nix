{ pkgs, config, ... }:
{
  home.packages = [
    pkgs.coreutils
    pkgs.ncurses
  ];

  programs.tmux = {
    enable = true;
    clock24 = true;
    shortcut = "a";
    # aggressiveResize = true; -- Disabled to be iTerm-friendly
    baseIndex = 1;
    newSession = true;
    # Stop tmux+escape craziness.
    escapeTime = 0;
    # Force tmux to use /tmp for sockets (WSL2 compat)
    secureSocket = false;

    plugins = with pkgs.tmuxPlugins; [
      sensible
      better-mouse-mode
      open
      sysstat
      # catppuccin
      pain-control
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-vim 'session'
        '';
      }
      {
        plugin = continuum; # not working properly?
        extraConfig = ''
          set -g @continuum-restore 'on'
        '';
      }
      {
        plugin = yank;
        extraConfig = ''
          set -g @yank_action 'copy-pipe'
        '';
      }
      {
        plugin = power-theme;
        extraConfig = ''
          set -g @tmux_power_theme 'forest'
        '';
      }
      {
        plugin = cpu;
        extraConfig = ''
          set -g status-right 'LA: #(sysctl -n vm.loadavg) #{cpu_bg_color} CPU: #{cpu_icon} #{cpu_percentage} | %a %h-%d %H:%M '
        '';
      }
      # {
      #   plugin = dracula;
      #   extraConfig = ''
      #     set -g @dracula-show-battery false
      #     set -g @dracula-show-powerline true
      #     set -g @dracula-refresh-rate 10
      #   '';
      # }
    ];

    # TODO: add session manager - dmux / smug looks nice
    # TODO: find a way to change screen-256 back to tmux-256, at least on linux, cuz screen breaks italics
    extraConfig = ''
      # https://old.reddit.com/r/tmux/comments/mesrci/tmux_2_doesnt_seem_to_use_256_colors/

      set -g default-terminal "screen-256color"

      set -ga terminal-overrides ",*256col*:Tc"
      set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
      set-environment -g COLORTERM "truecolor"

      set-option -g status-position top


      # Mouse works as expected
      set-option -g mouse on
      bind c new-window -c "#{pane_current_path}"

      # convenient config reload
      bind r source-file ~/.tmux.conf \; display-message "Tmux configuration reloaded."


      # Smart pane switching with awareness of Vim splits.
      # See: https://github.com/christoomey/vim-tmux-navigator
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|\.?n?vim?x?(-wrapped)?)(diff)?$'"
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


      # vim-like copypaste
      set-window-option -g mode-keys vi
      bind-key -T copy-mode-vi 'v' send-keys -X begin-selection

    '';
  };
}
