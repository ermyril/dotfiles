{ pkgs, config, ... }:
{
  home.packages = [
    pkgs.coreutils
    pkgs.ncurses
    pkgs.gnused
  ];

  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
    clock24 = true;
    shortcut = "a";
    # aggressiveResize = true; -- Disabled to be iTerm-friendly
    baseIndex = 1;
    newSession = true;
    # Stop tmux+escape craziness.
    escapeTime = 0;
    # Force tmux to use /tmp for sockets (WSL2 compat)
    #secureSocket = false;

    plugins = with pkgs.tmuxPlugins; [
      better-mouse-mode
      open
      sysstat
      pain-control
      vim-tmux-navigator
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavour 'mocha'
          set -g @catppuccin_window_status_style 'rounded'

          set -g status-right-length 100
          set -g status-left-length 100
          set -g status-left ""
          set -g status-right "#{E:@catppuccin_status_application}"


          set -g status-right "#[bg=#{@thm_flamingo},fg=#{@thm_crust}]#[reverse]#[noreverse]󰊚 "
          set -ag status-right "#[fg=#{@thm_fg},bg=#{@thm_surface_0}] #(uptime | sed -E 's/.*load averages?:[[:space:]]*//' | tr -d ',') "

          set -agF status-right "#{E:@catppuccin_status_cpu}"
          set -ag status-right "#{E:@catppuccin_status_session}"
          set -ag status-right "#{E:@catppuccin_status_uptime}"
        '';
      }
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
        plugin = cpu;
        extraConfig = ''
          set -g @cpu_medium_thresh "50"
          set -g @cpu_high_thresh "80"
        '';
      }
    ];

    # TODO: add session manager - dmux / smug looks nice
    extraConfig = ''
      set -g default-terminal "tmux-256color"

    # set -ga terminal-overrides ",*256col*:Tc"
    # set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
      set-environment -g COLORTERM "truecolor"

      set-option -g status-position top

      # Mouse works as expected
      set-option -g mouse on
      bind c new-window -c "#{pane_current_path}"

      # convenient config reload
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "Tmux configuration reloaded."

      # vim-like copypaste
      set-window-option -g mode-keys vi
      bind-key -T copy-mode-vi 'v' send-keys -X begin-selection

    '';
  };
}
