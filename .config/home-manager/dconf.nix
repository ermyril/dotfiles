# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      per-window = false;
      sources = [ (mkTuple [ "xkb" "us" ]) (mkTuple [ "xkb" "ru" ]) ];
      xkb-options = [ "terminate:ctrl_alt_bksp" "caps:escape"];
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "default";
      cursor-size = 24;
      cursor-theme = "Adwaita";
      enable-animations = true;
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      font-name = "Noto Sans,  10";
      icon-theme = "Adwaita";
      toolbar-style = "text";
    };

    "org/gnome/desktop/peripherals/keyboard" = {
      delay = mkUint32 200;
      repeat-interval = mkUint32 29;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      edge-scrolling-enabled = false;
      tap-to-click = false;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>q" "<Alt>F4" ];
      maximize = [];
      minimize = [ "<Super>comma" ];
      move-to-monitor-down = [];
      move-to-monitor-left = [];
      move-to-monitor-right = [];
      move-to-monitor-up = [];
      move-to-workspace-1 = [ "<Super><Shift>1" ];
      move-to-workspace-2 = [ "<Super><Shift>2" ];
      move-to-workspace-3 = [ "<Super><Shift>3" ];
      move-to-workspace-4 = [ "<Super><Shift>4" ];
      move-to-workspace-5 = [ "<Super><Shift>9" ];
      move-to-workspace-6 = [ "<Super><Shift>0" ];
      move-to-workspace-down = [];
      move-to-workspace-up = [];
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      switch-to-workspace-5 = [ "<Super>9" ];
      switch-to-workspace-6 = [ "<Super>0" ];
      switch-to-workspace-down = [ "<Primary><Super>Down" "<Primary><Super>j" ];
      switch-to-workspace-left = [];
      switch-to-workspace-right = [];
      switch-to-workspace-up = [ "<Primary><Super>Up" "<Primary><Super>k" ];
      toggle-maximized = [ "<Super>f" ];
      unmaximize = [];
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "icon:minimize,maximize,close";
      focus-mode = "click";
      num-workspaces = 6;
      workspace-names = [];
    };

    "org/gnome/mutter" = {
      attach-modal-dialogs = true;
      dynamic-workspaces = false;
      edge-tiling = true;
      focus-change-on-pointer-rest = true;
      workspaces-only-on-primary = false;
    };

    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-schedule-automatic = true;
      night-light-temperature = mkUint32 3500;
    };

    # "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
    #   binding = "<Super>z";
    #   command = "alacritty";
    #   name = "Alacritty";
    # };

    "org/gnome/shell" = {
      disable-extension-version-validation = true;
      disable-user-extensions = false;
      disabled-extensions = [];
      enabled-extensions = [ "pop-shell@system76.com" "dash-to-dock@micxgx.gmail.com" "native-window-placement@gnome-shell-extensions.gcampax.github.com" ];
      favorite-apps = [ "org.gnome.Epiphany.desktop" "org.gnome.Geary.desktop" "org.gnome.Calendar.desktop" "org.gnome.Music.desktop" "org.gnome.Photos.desktop" "org.gnome.Nautilus.desktop" "Alacritty.desktop" ];
      had-bluetooth-devices-setup = true;
      last-selected-power-profile = "power-saver";
      welcome-dialog-last-shown-version = "41.1";
    };

    "org/gnome/shell/extensions/auto-move-windows" = {
      application-list = [ "telegramdesktop.desktop:3" ];
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      apply-custom-theme = false;
      background-opacity = 0.8;
      custom-background-color = false;
      custom-theme-shrink = true;
      dash-max-icon-size = 48;
      dock-fixed = false;
      dock-position = "BOTTOM";
      extend-height = false;
      force-straight-corner = false;
      height-fraction = 0.52;
      hot-keys = false;
      intellihide-mode = "FOCUS_APPLICATION_WINDOWS";
      preferred-monitor = -2;
      preferred-monitor-by-connector = "eDP-1";
      running-indicator-style = "DOTS";
      transparency-mode = "DYNAMIC";
    };

    "org/gnome/shell/extensions/pop-shell" = {
      active-hint-border-radius = 15;
      active-hint = true;
      gap-inner = mkUint32 2;
      gap-outer = mkUint32 2;
      hint-color-rgba = "rgba(0, 139, 140, 1)";
      mouse-cursor-follows-active-window = false;
      search = [ "<Control>Space" ];
      show-title = false;
      smart-gaps = true;
      tile-by-default = true;
    };

    "org/gnome/shell/keybindings" = {
      open-application-menu = [];
      show-screenshot-ui = ["<Alt><Super>4"];
      screenshot = [ "<Control><Super>4" ];
      switch-to-application-1 = [];
      switch-to-application-2 = [];
      switch-to-application-3 = [];
      switch-to-application-4 = [];
      switch-to-application-5 = [];
      switch-to-application-6 = [];
      switch-to-application-7 = [];
      switch-to-application-8 = [];
      switch-to-application-9 = [];
      toggle-message-tray = [];
      toggle-overview = [];
    };

  };
}
