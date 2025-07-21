{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.mySystem.hyprland;
in
{
  options.mySystem.hyprland = {
    enable = mkEnableOption "Hyprland with custom BSP-style configuration";
    
    package = mkOption {
      type = types.package;
      default = pkgs.hyprland;
      description = "Hyprland package to use";
    };

    portalPackage = mkOption {
      type = types.package;
      default = pkgs.xdg-desktop-portal-hyprland;
      description = "XDG desktop portal package for Hyprland";
    };


    enableRofi = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Rofi launcher";
    };

    enableScreenshots = mkOption {
      type = types.bool;
      default = true;
      description = "Enable screenshot tools";
    };

    enableHyprpanel = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Hyprpanel status bar";
    };

    enableExtraHyprPackages = mkOption {
      type = types.bool;
      default = true;
      description = "Enable extra Hyprland-related packages (hyprnome, hyprshell)";
    };
  };

  config = mkIf cfg.enable {
    # Enable Hyprland
    programs.hyprland = {
      enable = true;
      package = cfg.package;
      portalPackage = cfg.portalPackage;
    };

    # XDG Desktop Portal configuration
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        cfg.portalPackage
        xdg-desktop-portal-gtk
      ];
      config = {
        common = {
          default = [ "gtk" ];
        };
        hyprland = {
          default = [ "hyprland" "gtk" ];
        };
      };
    };

    # Essential packages
    environment.systemPackages = with pkgs; [
      # Core Hyprland tools
      hyprpaper       # Wallpaper manager
      hypridle        # Idle daemon
      hyprlock        # Screen locker
      hyprshot        # Screenshots
      
      # Panel and UI
      rofi-wayland    # Application launcher
      dunst           # Notifications
      
      # System utilities
      wl-clipboard    # Clipboard management
      grim            # Screenshot utility
      slurp           # Screen region selector
      swayidle        # Idle management
      swaylock        # Lock screen
      
      # Audio and media
      pavucontrol     # PulseAudio volume control
      playerctl       # Media player control
      
      # File management
      nautilus        # File manager
      
      # Terminal and basic tools
      kitty           # Terminal emulator
      firefox         # Web browser
      
      # Fonts for proper rendering
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      font-awesome
      
    ] ++ optionals cfg.enableRofi [ rofi-wayland ]
      ++ optionals cfg.enableScreenshots [ grim slurp hyprshot ]
      ++ optionals cfg.enableHyprpanel [ hyprpanel ]
      ++ optionals cfg.enableExtraHyprPackages [ hyprnome hyprshell ];

    # Enable sound
    services.pipewire = {
      enable = true;
      pulse.enable = true;
      jack.enable = true;
      alsa.enable = true;
    };

    # Enable bluetooth
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    # Enable NetworkManager
    networking.networkmanager.enable = true;

    # Enable polkit for privilege escalation
    security.polkit.enable = true;

    # Enable GDM display manager
    services.xserver.enable = lib.mkDefault true;
    services.displayManager.gdm = {
      enable = true;
      wayland = true;
    };

    # Basic fonts (additional styling handled by stylix)
    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      font-awesome
      fira-code
      fira-code-symbols
    ];

    # Security and session management
    security.pam.services.hyprlock = {};
    
    # Environment variables for Wayland
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";                    # Electron apps use Wayland
      MOZ_ENABLE_WAYLAND = "1";                # Firefox use Wayland
      QT_QPA_PLATFORM = "wayland";             # Qt apps use Wayland
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
    };

    # Enable dbus
    services.dbus.enable = true;
    
  };
}



