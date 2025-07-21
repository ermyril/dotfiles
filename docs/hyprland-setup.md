# Hyprland BSP Configuration

A comprehensive Hyprland setup with Binary Space Partitioning (BSP) window management, inspired by Cosmic Desktop and yabai hotkeys.

## Overview

This configuration provides:
- BSP-style window management using Hyprland's dwindle layout
- Cosmic Desktop and yabai-inspired keybindings
- Waybar panel with system information
- Complete Wayland desktop environment

## Files Structure

```
modules/nixos/hyprland.nix              # System-level Hyprland module
home-manager/modules/hyprland-config.nix # Complete user-level configuration
```

## Installation

### Modular Approach (Recommended)

Simply import the modules in your configuration:

**In your NixOS flake or configuration:**
```nix
imports = [
  ./modules/nixos/hyprland.nix  # System-level
];

programs.hyprland-custom.enable = true;
```

**In your home-manager configuration:**
```nix
imports = [
  ./home-manager/modules/hyprland-config.nix  # User-level (auto-enables)
];
```

The Hyprland module is self-contained and enables itself when imported, following the modular configuration principle.

### Manual Control

If you want explicit control:
```nix
# In home-manager
wayland.windowManager.hyprland-custom.enable = false;  # Disable if needed
```

### Build System
```bash
sudo nixos-rebuild switch --flake .#your-hostname
```

## Keybindings Cheatsheet

### Application Shortcuts
| Key | Action |
|-----|--------|
| `Super + Q` | Open terminal (kitty) |
| `Ctrl + Space` | Open launcher (rofi) |
| `Super` (alone) | Open launcher (rofi) |
| `Super + E` | Open file manager (nautilus) |
| `Super + B` | Open browser (firefox) |

### Window Management
| Key | Action |
|-----|--------|
| `Super + W` | Close window |
| `Super + V` | Toggle floating |
| `Super + F` | Toggle fullscreen |
| `Super + J` | Toggle split direction |
| `Super + P` | Toggle pseudotile |

### Window Navigation (Vim-style)
| Key | Action |
|-----|--------|
| `Super + H` | Focus window left |
| `Super + J` | Focus window down |
| `Super + K` | Focus window up |
| `Super + L` | Focus window right |

### Window Movement (Cosmic-style)
| Key | Action |
|-----|--------|
| `Super + Shift + H` | Move window left |
| `Super + Shift + J` | Move window down |
| `Super + Shift + K` | Move window up |
| `Super + Shift + L` | Move window right |

### Window Manipulation (yabai-style)
| Key | Action |
|-----|--------|
| `Super + Alt + H` | Swap/resize window left |
| `Super + Alt + J` | Swap/resize window down |
| `Super + Alt + K` | Swap/resize window up |
| `Super + Alt + L` | Swap/resize window right |

### Workspaces
| Key | Action |
|-----|--------|
| `Super + 1-9, 0` | Switch to workspace |
| `Super + Shift + 1-9, 0` | Move window to workspace |
| `Super + Mouse Wheel` | Cycle through workspaces |

### Special Workspace (Scratchpad)
| Key | Action |
|-----|--------|
| `Super + S` | Toggle scratchpad |
| `Super + Shift + S` | Move window to scratchpad |

### Screenshots
| Key | Action |
|-----|--------|
| `Super + Print` | Screenshot entire screen |
| `Super + Shift + Print` | Screenshot active window |
| `Super + Alt + Print` | Screenshot selected region |

### System Controls
| Key | Action |
|-----|--------|
| `Super + Escape` | Lock screen |
| `Super + Shift + E` | Exit Hyprland |
| Volume/Brightness Keys | Media controls |

### Mouse Actions
| Key + Mouse | Action |
|-------------|--------|
| `Super + Left Click + Drag` | Move window |
| `Super + Right Click + Drag` | Resize window |

## Layout Behavior

### BSP (Binary Space Partitioning)
- Windows automatically split existing space
- New windows create binary partitions
- Smart resizing maintains proportions
- Pseudotiling for better window management

### Dwindle Layout Settings
- `preserve_split = true` - Maintains split ratios
- `smart_split = true` - Intelligent splitting
- `smart_resizing = true` - Proportional resizing
- `force_split = 2` - Forces right/down splits

## Panel (Waybar)

Located at the top of the screen with:
- **Left**: Workspace indicators with icons
- **Center**: Active window title
- **Right**: System information (CPU, memory, network, audio, clock)

### Workspace Icons
- Workspace 1: 󰈹 (terminal)
- Workspace 2:  (web)
- Workspace 3:  (files)
- Workspace 4:  (media)
- Workspace 5: 󰇮 (mail)

## Customization

### Change Default Applications
Override options in your home-manager configuration:
```nix
{
  wayland.windowManager.hyprland-custom = {
    terminal = "alacritty";          # Default: kitty
    launcher = "wofi --show drun";   # Default: rofi -show drun
    fileManager = "thunar";          # Default: nautilus
    browser = "chromium";            # Default: firefox
  };
}
```

### Module Options
System-level options in `modules/nixos/hyprland.nix`:
```nix
programs.hyprland-custom = {
  enable = true;
  enableWaybar = true;      # Status bar
  enableRofi = true;        # Launcher
  enableScreenshots = true; # Screenshot tools
};
```

## Included Software

### Core Components
- **Hyprland**: Wayland compositor
- **Waybar**: Status bar/panel
- **Rofi**: Application launcher
- **Dunst**: Notification daemon
- **Kitty**: Terminal emulator

### Utilities
- **hyprshot**: Screenshot tool
- **hyprpaper**: Wallpaper manager
- **hyprlock**: Screen locker
- **wl-clipboard**: Clipboard management
- **grim/slurp**: Screen capture utilities

### Audio & Media
- **PipeWire**: Audio system
- **pavucontrol**: Volume control GUI
- **playerctl**: Media player control

## Troubleshooting

### Common Issues

**Hyprland won't start:**
- Check if GDM is enabled: `services.xserver.displayManager.gdm.enable = true;`
- Ensure Wayland is enabled: `services.xserver.displayManager.gdm.wayland = true;`

**No audio:**
- Verify PipeWire is running: `systemctl --user status pipewire`
- Check audio devices: `wpctl status`

**Applications don't launch:**
- Check if XDG portal is running: `systemctl --user status xdg-desktop-portal-hyprland`
- Verify environment variables are set

**Panel not showing:**
- Restart Waybar: `pkill waybar && waybar &`
- Check Waybar config: `waybar --log-level debug`

### Logs and Debugging
- Hyprland logs: `journalctl --user -u hyprland`
- Check Hyprland config: `hyprctl config`
- Monitor events: `hyprctl monitors`

## Philosophy

This configuration follows these principles:
1. **Spatial Navigation**: Window focus based on direction, not arbitrary order
2. **Predictable Splitting**: New windows follow consistent partitioning rules  
3. **Muscle Memory**: Familiar keybindings from established window managers
4. **Visual Feedback**: Clear workspace indicators and window states
5. **Efficiency**: Minimal mouse dependency, keyboard-driven workflow

## References

- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Cosmic Desktop Shortcuts](https://system76.com/cosmic)
- [yabai Configuration](https://github.com/koekeishiya/yabai)
- [BSP Window Management](https://en.wikipedia.org/wiki/Tiling_window_manager#Binary_space_partitioning)