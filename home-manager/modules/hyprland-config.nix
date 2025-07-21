{ config, lib, pkgs, ... }:

{
  # Use standard Hyprland home-manager module with custom configuration
  wayland.windowManager.hyprland = {
    enable = true;
    
    settings = {
        # Monitor configuration
        monitor = [
          ",preferred,auto,1"  # Auto-detect monitors
        ];

        # Input configuration
        input = {
          kb_layout = "us,ru";
          kb_options = "caps:escape,grp:win_space_toggle";
          
          # Fast repeat rate and short delay
          repeat_rate = 40;   # 40 Hz repeat rate 
          repeat_delay = 200; # 200ms delay before repeat starts
          
          follow_mouse = 1;
          sensitivity = 0; # -1.0 - 1.0, 0 means no modification
          
          touchpad = {
            natural_scroll = true;
            disable_while_typing = true;
            tap-to-click = true;
          };
        };

        # General configuration (colors handled by stylix)
        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;
          
          layout = "dwindle";  # BSP-like layout
          allow_tearing = false;
        };

        # Decoration settings (colors handled by stylix)
        decoration = {
          rounding = 8;
          
          blur = {
            enabled = true;
            size = 3;
            passes = 1;
            vibrancy = 0.1696;
          };
          
          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
          };
        };

        # Animation settings
        animations = {
          enabled = true;
          
          bezier = [
            "myBezier, 0.05, 0.9, 0.1, 1.05"
          ];
          
          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        # Dwindle layout (BSP-like)
        dwindle = {
          pseudotile = true;
          preserve_split = true;
          smart_split = true;
          smart_resizing = true;
          force_split = 2;  # Force split right/down
        };

        # Master layout as alternative
        master = {
          new_status = "master";
          new_on_top = false;
        };

        # Misc settings
        misc = {
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          mouse_move_enables_dpms = true;
          key_press_enables_dpms = true;
        };

        # Window rules
        windowrule = [
          # "float, ^(pavucontrol)$"
          # "float, ^(blueman-manager)$"
          # "float, ^(nm-connection-editor)$"
          # "float, ^(rofi)$"
          # "pin, ^(rofi)$"
        ];

        windowrulev2 = [
          "suppressevent maximize, class:.*"  # Prevent maximize
          "float, class:^(org.kde.polkit-kde-authentication-agent-1)$"
        ];

        bind = [
          # System controls
          "SUPER, Q, killactive"
          "SUPER, E, exec, nautilus"
          "CTRL, SPACE, exec, rofi -show drun"
          "SUPER, B, exec, firefox"
          
          # Window management - Cosmic style
          "SUPER_SHIFT, E, exit"
          "SUPER, T, togglefloating"
          "SUPER, F, fullscreen, 0"
          "SUPER, P, pseudo"  # dwindle pseudotile
          "SUPER, V, togglesplit"  # dwindle split toggle
          "SUPER, ., togglesplit"
          
          # Move focus - vim-like with BSP behavior
          "SUPER, H, movefocus, l"
          "SUPER, L, movefocus, r"
          "SUPER, K, movefocus, u"
          "SUPER, J, movefocus, d"
          
          # Move windows - Cosmic/yabai inspired
          "SUPERCTRL, H, movewindow, l"
          "SUPERCTRL, L, movewindow, r"
          "SUPERCTRL, K, movewindow, u"
          "SUPERCTRL, J, movewindow, d"
          
          # Swap windows (yabai-inspired)  
          "SUPER_SHIFT, H, swapwindow, l"
          "SUPER_SHIFT, L, swapwindow, r"
          "SUPER_SHIFT, K, swapwindow, u"
          "SUPER_SHIFT, J, swapwindow, d"
          
          # Workspaces
          "SUPER, 1, workspace, 1"
          "SUPER, 2, workspace, 2"
          "SUPER, 3, workspace, 3"
          "SUPER, 4, workspace, 4"
          "SUPER, 5, workspace, 5"
          "SUPER, 6, workspace, 6"
          "SUPER, 7, workspace, 7"
          "SUPER, 8, workspace, 8"
          "SUPER, 9, workspace, 9"
          "SUPER, 0, workspace, 10"
          
          # Move windows to workspaces
          "SUPER_SHIFT, 1, movetoworkspace, 1"
          "SUPER_SHIFT, 2, movetoworkspace, 2"
          "SUPER_SHIFT, 3, movetoworkspace, 3"
          "SUPER_SHIFT, 4, movetoworkspace, 4"
          "SUPER_SHIFT, 5, movetoworkspace, 5"
          "SUPER_SHIFT, 6, movetoworkspace, 6"
          "SUPER_SHIFT, 7, movetoworkspace, 7"
          "SUPER_SHIFT, 8, movetoworkspace, 8"
          "SUPER_SHIFT, 9, movetoworkspace, 9"
          "SUPER_SHIFT, 0, movetoworkspace, 10"
          
          # Scroll through existing workspaces
          "SUPER, mouse_down, workspace, e+1"
          "SUPER, mouse_up, workspace, e-1"
          
          # Special workspace (scratchpad)
          "SUPER, S, togglespecialworkspace, magic"
          "SUPER_SHIFT, S, movetoworkspace, special:magic"
          
          # Layout management 
          "SUPER_ALT, R, layoutmsg, orientationleft"
          "SUPER_ALT, Y, layoutmsg, orientationtop"  
          "SUPER_ALT, E, layoutmsg, orientationright"
          "SUPER_ALT, B, layoutmsg, orientationbottom"
          
          # Screenshots (Cosmic-inspired)
          "SUPER, Print, exec, hyprshot -m region"
          "SUPER_SHIFT, Print, exec, hyprshot -m window"
          "SUPER_ALT, Print, exec, hyprshot -m output"
          
          # Volume and brightness
          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPrev, exec, playerctl previous"
          ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"
          ", XF86MonBrightnessUp, exec, brightnessctl set 10%+"
          
          # Lock screen
          "SUPER, ESCAPE, exec, hyprlock"
        ];

        # Mouse bindings
        bindm = [
          "SUPER, mouse:272, movewindow"   # Move windows with Super + left mouse
          "SUPER, mouse:273, resizewindow" # Resize windows with Super + right mouse
        ];

        # Resize mode bindings
        binde = [
          # Resize windows (yabai-style with Alt)
          "SUPER_ALT, H, resizeactive, -10 0"
          "SUPER_ALT, L, resizeactive, 10 0"
          "SUPER_ALT, K, resizeactive, 0 -10"
          "SUPER_ALT, J, resizeactive, 0 10"
        ];

        # Startup applications
        exec-once = [
          "hyprpanel"
          "hyprpaper"
          "dunst"
          "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1"
          "wl-paste --type text --watch cliphist store"
          "wl-paste --type image --watch cliphist store"
        ];

        # Environment variables
        env = [
          "XCURSOR_SIZE,24"
          "QT_QPA_PLATFORMTHEME,qt5ct"
        ];
      };
    };


  # HyprPanel configuration
  programs.hyprpanel = {
    enable = true;
    
    # Disable assertion since HyprPanel handles notifications internally
    dontAssertNotificationDaemons = true;
    
    settings = {
      bar.launcher.autoDetectIcon = true;
      bar.workspaces.show_icons = true;
      
      menus.clock = {
        time.military = true;
        weather.unit = "metric";
      };
      
      theme = {
        font = {
          name = "JetBrainsMono Nerd Font";
          size = "14px";
        };
        bar.transparent = true;
        name = "catppuccin_latte";
      };
      
      # Panel layout for primary monitor
      "bar.layouts" = {
        "0" = {
          left = [ "dashboard" "workspaces" ];
          middle = [ "media" ];
          right = [  "network" "bluetooth" "systray" "notifications" "clock" "volume"];
        };
      };
    };
  };

  # Application launcher
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    
    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      drun-display-format = "{name}";
      disable-history = false;
      sidebar-mode = true;
      display-drun = "Apps";
      display-run = "Run";
      display-window = "Windows";
    };
  };

  # GTK configuration (themes handled by stylix)
  gtk.enable = true;
  
  # Additional Hyprland-related tools
  home.packages = with pkgs; [
    # Clipboard management
    wl-clipboard
    cliphist
    
    # File management
    nautilus
    
    # Basic applications
    firefox
    kitty
  ];

  # Services that should run with the user session
  systemd.user.services = {
    # Ensure clipboard history works
    cliphist = {
      Unit = {
        Description = "Clipboard history manager";
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist}/bin/cliphist store";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
