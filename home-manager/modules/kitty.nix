{ config, lib, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    
    font = {
      name = "monospace";
      size = 12.0;
    };
    
    settings = {
      # Cursor configuration
      cursor = "#cccccc";
      cursor_shape = "block";
      cursor_blink_interval = "0.5";
      cursor_stop_blinking_after = "15.0";
      
      # Scrollback
      scrollback_lines = 2000;
      scrollback_pager = "less +G -R";
      wheel_scroll_multiplier = "4.5";
      
      # URL handling
      url_color = "#0087BD";
      url_style = "curly";
      open_url_modifiers = "kitty_mod";
      open_url_with = "default";
      
      # Selection
      copy_on_select = "no";
      rectangle_select_modifiers = "ctrl+alt";
      select_by_word_characters = ":@-./_~?&=%+#";
      click_interval = "0.5";
      
      # Mouse
      mouse_hide_wait = "3.0";
      focus_follows_mouse = "no";
      
      # Performance
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = "yes";
      
      
      # Bell
      visual_bell_duration = "0.0";
      enable_audio_bell = "yes";
      window_alert_on_bell = "yes";
      bell_on_tab = "yes";
      
      # Window management
      remember_window_size = "yes";
      initial_window_width = 640;
      initial_window_height = 400;
      hide_window_decorations = "yes";
      wayland_titlebar_color = "#1B2B34";
      macos_titlebar_color = "#1B2B34";
      enabled_layouts = "*";
      
      # Window appearance
      window_resize_step_cells = 2;
      window_resize_step_lines = 2;
      window_border_width = 10;
      window_margin_width = 10;
      window_padding_width = 0;
      active_border_color = "#00ff00";
      inactive_border_color = "#cccccc";
      bell_border_color = "#ff5a00";
      inactive_text_alpha = "1.0";
      
      # Tab bar
      tab_bar_edge = "bottom";
      tab_separator = " ┇";
      active_tab_foreground = "#000";
      active_tab_background = "#eee";
      active_tab_font_style = "bold-italic";
      inactive_tab_foreground = "#444";
      inactive_tab_background = "#999";
      inactive_tab_font_style = "normal";
      
      # Opacity and selection (theme will override colors)
      background_opacity = "1.0";
      dynamic_background_opacity = "no";
      dim_opacity = "0.75";
      
      # Terminal settings - start tmux by default
      shell = "${pkgs.tmux}/bin/tmux";
      editor = ".";
      close_on_child_death = "no";
      allow_remote_control = "no";
      clipboard_control = "write-clipboard write-primary";
      term = "xterm-256color";
      
      # Modifier key
      kitty_mod = "ctrl+shift";
      
      # macOS specific
      macos_hide_titlebar = "no";
      macos_option_as_alt = "yes";
      macos_hide_from_tasks = "no";
      
      # Shortcuts
      clear_all_shortcuts = "no";
    };
    
    # Use GitHub Dark theme from kitty-themes
    themeFile = "GitHub_Dark";
    
    # Keyboard shortcuts
    keybindings = {
      # Clipboard
      "kitty_mod+c" = "copy_to_clipboard";
      "kitty_mod+v" = "paste_from_clipboard";
      "kitty_mod+s" = "paste_from_selection";
      "shift+insert" = "paste_from_selection";
      "kitty_mod+o" = "pass_selection_to_program";
      
      # Scrolling
      "kitty_mod+up" = "scroll_line_up";
      "kitty_mod+down" = "scroll_line_down";
      "kitty_mod+k" = "scroll_line_up";
      "kitty_mod+j" = "scroll_line_down";
      "kitty_mod+page_up" = "scroll_page_up";
      "kitty_mod+page_down" = "scroll_page_down";
      "kitty_mod+home" = "scroll_home";
      "kitty_mod+end" = "scroll_end";
      "kitty_mod+h" = "show_scrollback";
      
      # Windows
      "kitty_mod+enter" = "new_window";
      "kitty_mod+n" = "new_os_window";
      "kitty_mod+w" = "close_window";
      "kitty_mod+]" = "next_window";
      "kitty_mod+[" = "previous_window";
      "kitty_mod+f" = "move_window_forward";
      "kitty_mod+b" = "move_window_backward";
      "kitty_mod+`" = "move_window_to_top";
      "kitty_mod+r" = "start_resizing_window";
      
      # Window numbers
      "kitty_mod+1" = "first_window";
      "kitty_mod+2" = "second_window";
      "kitty_mod+3" = "third_window";
      "kitty_mod+4" = "fourth_window";
      "kitty_mod+5" = "fifth_window";
      "kitty_mod+6" = "sixth_window";
      "kitty_mod+7" = "seventh_window";
      "kitty_mod+8" = "eighth_window";
      "kitty_mod+9" = "ninth_window";
      "kitty_mod+0" = "tenth_window";
      
      # Tabs
      "kitty_mod+right" = "next_tab";
      "kitty_mod+left" = "previous_tab";
      "kitty_mod+t" = "new_tab";
      "kitty_mod+q" = "close_tab";
      "kitty_mod+l" = "next_layout";
      "kitty_mod+." = "move_tab_forward";
      "kitty_mod+," = "move_tab_backward";
      "kitty_mod+alt+t" = "set_tab_title";
      
      # Font size
      "kitty_mod+equal" = "change_font_size all +1.0";
      "kitty_mod+minus" = "change_font_size all -1.0";
      "kitty_mod+backspace" = "change_font_size all 0";
      
      # Hints
      "kitty_mod+e" = "kitten hints";
      "kitty_mod+p>f" = "kitten hints --type path --program -";
      "kitty_mod+p>shift+f" = "kitten hints --type path";
      "kitty_mod+p>l" = "kitten hints --type line --program -";
      "kitty_mod+p>w" = "kitten hints --type word --program -";
      
      # Misc
      "kitty_mod+f11" = "toggle_fullscreen";
      "kitty_mod+u" = "input_unicode_character";
      "kitty_mod+f2" = "edit_config_file";
      "kitty_mod+escape" = "kitty_shell window";
      
      # Background opacity
      "kitty_mod+a>m" = "set_background_opacity +0.1";
      "kitty_mod+a>l" = "set_background_opacity -0.1";
      "kitty_mod+a>1" = "set_background_opacity 1";
      "kitty_mod+a>d" = "set_background_opacity default";
    };
  };
  
  # tmux is launched directly as the shell, no autostart file needed
}