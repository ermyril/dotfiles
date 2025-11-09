# Dotfiles Architecture Documentation

**Last Updated:** 2025-11-09
**Purpose:** Reference document for understanding the current state and architecture of this NixOS/nix-darwin configuration

---

## Table of Contents

1. [Overview](#overview)
2. [Flake Structure](#flake-structure)
3. [Module Organization](#module-organization)
4. [Host Configurations](#host-configurations)
5. [Architectural Patterns](#architectural-patterns)
6. [Current State & Issues](#current-state--issues)
7. [Refactoring Considerations](#refactoring-considerations)

---

## Overview

This repository contains a unified Nix flake configuration managing multiple systems across different platforms:
- **2 NixOS hosts** (Linux desktop and laptop)
- **1 nix-darwin host** (macOS laptop)

### Design Philosophy

Per `CLAUDE.md`, the configuration follows these principles:

1. **Modularity First**: Each module should be self-contained and include all dependencies
2. **Cross-platform Support**: Shared modules work on both Linux and macOS where possible
3. **Declarative Configuration**: All settings managed through the flake
4. **Git-tracked Files**: All nix files must be in git index before builds (flake requirement)

### Repository Structure

```
.
├── flake.nix                    # Main flake configuration
├── flake.lock                   # Locked dependency versions
├── CLAUDE.md                    # Project instructions for AI assistants
├── .claude/                     # Claude Code session logs and docs
│   ├── session_log.md          # Recent debugging sessions
│   └── ARCHITECTURE.md         # This file
├── hosts/                       # Host-specific configurations
│   ├── north/                  # Desktop (NixOS)
│   ├── minibook/               # Laptop (NixOS)
│   └── macbook/                # Laptop (macOS)
├── modules/                     # System-level modules
│   ├── shared/                 # Cross-platform system modules
│   ├── nixos/                  # Linux-specific system modules
│   └── darwin/                 # macOS-specific system modules
├── home-manager/                # User-level configurations
│   ├── default.nix             # Common home-manager config
│   ├── modules/                # Home-manager modules
│   └── platforms/              # Platform-specific HM configs
├── dotfiles/                    # Legacy dotfiles (mostly unused)
└── wallpapers/                  # Wallpaper images for stylix

```

---

## Flake Structure

### Inputs

The flake declares the following dependencies:

```nix
inputs = {
  nixpkgs              # Main package repository
  home-manager         # User environment management
  nix-darwin           # macOS system management
  nur                  # Nix User Repository
  kmonad               # Keyboard remapping
  stylix               # Unified theming
  flake-utils          # Flake utilities
  nixpkgs-firefox-darwin  # Firefox for macOS
}
```

**Key Configuration:**
- All inputs follow `nixpkgs` to ensure version consistency
- Flake inputs are exposed via `outputs.inputs` for host access

### Outputs

The flake produces:

1. **`nixosConfigurations`**: NixOS system configurations
   - `north` (x86_64-linux)
   - `minibook` (x86_64-linux)

2. **`darwinConfigurations`**: macOS system configurations
   - `macbook` (aarch64-darwin)

---

## Module Organization

### Shared Modules (`modules/shared/`)

Cross-platform modules that work on both NixOS and nix-darwin:

| Module | Purpose | Key Features |
|--------|---------|--------------|
| `nix-settings.nix` | Core Nix configuration | Flakes enabled, binary caches, GC settings |
| `users.nix` | User management | Defines `mySystem.primaryUser` option, configures fish shell |
| `keyboard.nix` | Keyboard layout | XKB config: US/RU layouts, Caps→Escape, Win+Space to toggle |
| `packages/common.nix` | Essential packages | vim, git, curl, htop, kitty, python3, etc. |

**Pattern:** Shared modules use platform detection (`pkgs.stdenv.isLinux`, `pkgs.stdenv.isDarwin`) for conditional config.

### NixOS Modules (`modules/nixos/`)

Linux-specific system modules:

| Module | Purpose | Configuration Type |
|--------|---------|-------------------|
| `packages.nix` | Linux-specific packages | Static list (mesa, vulkan, gnome-tweaks, etc.) |
| `deluge.nix` | BitTorrent client | **Configurable** via `mySystem.deluge.*` options |
| `reaper.nix` | Pro audio (DAW) | **Configurable** via `mySystem.reaper.*` options |
| `hyprland.nix` | Wayland compositor | **Configurable** via `mySystem.hyprland.*` options |

**Configurable Modules Pattern:**

```nix
# modules/nixos/reaper.nix
options.mySystem.reaper = {
  enable = mkEnableOption "...";
  enableJackGUI = mkOption { ... };
};

config = mkIf cfg.enable {
  # All related configuration here
  services.pipewire = { ... };
  environment.systemPackages = [ ... ];
  home-manager.users.${config.mySystem.primaryUser} = { ... };
};
```

This pattern ensures:
- ✅ All dependencies included in one module
- ✅ Can be enabled/disabled cleanly
- ✅ References `mySystem.primaryUser` for consistency

### Darwin Modules (`modules/darwin/`)

macOS-specific system modules:

| Module | Purpose |
|--------|---------|
| `packages.nix` | macOS window managers (yabai, skhd) |

**Note:** Currently minimal; macOS config is mostly in `hosts/macbook/configuration.nix`

### Home Manager Modules (`home-manager/`)

User-level configurations managed by home-manager:

#### Core Structure

```
home-manager/
├── default.nix              # Imports common modules, defines common packages
├── platforms/
│   ├── linux.nix           # Imports modules/linux.nix
│   └── darwin.nix          # Imports modules/macos/macos.nix
└── modules/
    ├── Core modules (cross-platform)
    │   ├── tmux.nix
    │   ├── vim.nix
    │   ├── fish.nix
    │   ├── kitty.nix
    │   ├── firefox.nix
    │   ├── ssh.nix
    │   ├── dotfiles.nix
    │   └── stylix.nix
    ├── Platform-specific
    │   ├── linux.nix        # Linux-specific HM config
    │   ├── emacs.nix        # Linux only (for now)
    │   ├── dconf.nix        # GNOME settings
    │   └── macos/
    │       ├── macos.nix
    │       └── home-manager-spotlight-hack.nix
    └── Optional
        ├── syncthing.nix     # Disabled
        ├── kmonad.nix
        └── hyprland-config.nix
```

#### Key Modules

**`default.nix`** - Common baseline imported by all hosts:
- Core tools: git, gh, claude-code, ripgrep, terraform, kubectl
- Development: go, gopls, cmake, nixpkgs-fmt, ghc
- Utilities: neofetch, htop, btop, jq, ffmpeg-full

**`platforms/linux.nix`** → `modules/linux.nix`:
- Development: vscode, ctags, insomnia
- GNOME: extensions (pop-shell, dash-to-dock, hide-top-bar, etc.)
- Applications: logseq, gimp, vlc, obs-studio
- Git config with GPG signing
- Password store integration

**`platforms/darwin.nix`** → `modules/macos/macos.nix`:
- macOS-specific tooling and configs

**`modules/stylix.nix`** - Unified theming:
- Theme: Catppuccin Mocha (base16)
- Wallpaper: `wallpapers/ark.jpg`
- Fonts: FiraCode Nerd Font (mono), Fira Sans (UI)
- Targets: kitty, tmux, vim, fish, fzf, firefox

**`modules/fish.nix`** - Shell configuration:
- Custom prompt with git status
- Platform detection for macOS-specific aliases
- Plugins: grc, done, autopair, z, bass
- macOS-only: Zscaler controls, fnm, work environment variables

---

## Host Configurations

### north (Desktop - NixOS)

**Location:** `hosts/north/configuration.nix`
**System:** x86_64-linux
**Hardware:** Desktop with NVIDIA GPU, 3440x1440@180Hz monitor

#### System Configuration

```nix
# Primary configuration
mySystem.primaryUser = "ermyril";
mySystem.deluge.enable = true;
mySystem.reaper.enable = true;

# Desktop environments
services.desktopManager.cosmic.enable = true;
services.desktopManager.gnome.enable = true;
services.displayManager.gdm.enable = true;

# Graphics
services.xserver.videoDrivers = ["nvidia"];
hardware.nvidia = {
  modesetting.enable = true;
  powerManagement.enable = false;  # Prevents freeze on shutdown
  open = false;
  nvidiaSettings = true;
};

# Disabled nvidia suspend services (prevents issues)
systemd.services.nvidia-suspend.enable = false;
systemd.services.nvidia-resume.enable = false;
```

#### Notable Features

- **Display:** Custom 180Hz configuration for ultrawide monitor
- **Virtualization:** libvirtd, VirtualBox with extension pack
- **Graphics:** Mesa, Vulkan, OpenGL, 32-bit support
- **Video Production:** OBS Studio with CUDA, many plugins
- **Streaming:** Sunshine enabled for game streaming

#### Home Manager Users

- **ermyril** (primary): Full desktop setup with stylix
- **penguin**: Minimal (vim + tmux only)

#### Module Imports (from flake)

```nix
modules = [
  ./hosts/north/configuration.nix
  ./modules/shared/nix-settings.nix
  ./modules/shared/users.nix
  ./modules/shared/packages/common.nix
  ./modules/shared/keyboard.nix
  ./modules/nixos/packages.nix
  ./modules/nixos/deluge.nix
  ./modules/nixos/reaper.nix
  # ./modules/nixos/hyprland.nix  # Commented out
]
```

#### Local Module Imports

```nix
# In hosts/north/configuration.nix
imports = [
  ./hardware-configuration.nix
  ./modules/ollama.nix
  # ./modules/plasma.nix    # Commented out
  # ./modules/bottles.nix   # Commented out
];
```

### minibook (Laptop - NixOS)

**Location:** `hosts/minibook/configuration.nix`
**System:** x86_64-linux
**Hardware:** Chuwi MiniBook X (convertible laptop with rotation sensor)

#### System Configuration

```nix
mySystem.primaryUser = "ermyril";
mySystem.deluge.enable = true;
mySystem.reaper.enable = true;

# Desktop
services.displayManager.gdm.enable = true;
services.desktopManager.gnome.enable = true;

# Boot
boot.loader.grub.enable = true;
boot.loader.grub.enableCryptodisk = true;  # Encrypted setup

# Convertible hardware support
hardware.sensor.iio.enable = true;
environment.etc.machine-info.text = "CHASSIS=convertible";
```

#### Notable Features

- **Encryption:** Home directory encryption, TPM 2.0 support
- **Screen Rotation:** Custom GDM monitor config for portrait mode
- **Kernel:** Latest kernel with custom patches for hardware
- **Auto-rotation:** iio-sensor-proxy for accelerometer
- **Virtualization:** Docker enabled
- **Power:** zramSwap enabled

#### Module Organization

**Different pattern from north:** Uses many local module files instead of flake-level modules:

```nix
imports = [
  ./hardware-configuration.nix
  ./minibook.nix           # Hardware-specific (rotation, TPM, etc.)
  ./cron.nix
  ./vars.nix
  ./shells.nix
  ./packages.nix           # Local package list
  ./gc.nix                 # Garbage collection config
  ./filesystems.nix
  ./nur.nix
  ./home-encryption.nix
  ./programs/kmonad/kmonad.nix
  ./programs/waydroid.nix
];
```

#### Home Manager

- **ermyril** (primary): Does NOT import `platforms/linux.nix` (why?)
  - Only gets default.nix + stylix
  - Missing GNOME extensions and Linux-specific tools

**Note:** This inconsistency vs. north may be unintentional.

### macbook (Laptop - macOS)

**Location:** `hosts/macbook/configuration.nix`
**System:** aarch64-darwin
**User:** mikhaini

#### System Configuration

```nix
mySystem.primaryUser = "mikhaini";
system.primaryUser = "mikhaini";

# Disable nix daemon (managed by nix-darwin)
nix.enable = false;

# Finder settings
system.defaults.finder = {
  AppleShowAllExtensions = true;
  AppleShowAllFiles = true;
  ShowPathbar = true;
  ShowStatusBar = true;
  FXPreferredViewStyle = "clmv";  # Column view
};
```

#### Module Imports (from flake)

```nix
modules = [
  ./hosts/macbook/configuration.nix
  ./modules/shared/nix-settings.nix
  ./modules/shared/users.nix
  ./modules/shared/packages/common.nix
  ./modules/darwin/packages.nix
]
```

#### Home Manager

- **mikhaini**: Full home-manager setup with darwin platform config + stylix
- Includes work-specific environment variables and tooling

---

## Architectural Patterns

### 1. The `mySystem` Options Pattern

**Purpose:** Provide a consistent namespace for custom modules across the configuration.

**Implementation:**

```nix
# modules/shared/users.nix
options.mySystem.primaryUser = lib.mkOption {
  type = lib.types.str;
  description = "Primary user name";
};

options.mySystem.reaper = {
  enable = mkEnableOption "...";
  # ... other options
};

config = mkIf cfg.enable {
  users.users.${config.mySystem.primaryUser}.extraGroups = [ "jackaudio" "audio" ];
};
```
**Benefits:**
- Avoids conflicts with upstream NixOS/nix-darwin options
- Clear indication of custom configuration

**Current Usage:**
- `mySystem.primaryUser` (shared/users.nix)
- `mySystem.primaryUserFullName` (shared/users.nix)
- `mySystem.deluge.*` (nixos/deluge.nix)
- `mySystem.reaper.*` (nixos/reaper.nix)
- `mySystem.hyprland.*` (nixos/hyprland.nix)

### 2. Platform Detection

**Pattern:** Use `pkgs.stdenv` platform checks for conditional configuration.

```nix
# Example from modules/shared/users.nix
users.users.${config.mySystem.primaryUser} = {
  shell = pkgs.fish;
} // lib.optionalAttrs pkgs.stdenv.isLinux {
  isNormalUser = true;
  extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
} // lib.optionalAttrs pkgs.stdenv.isDarwin {
  name = config.mySystem.primaryUser;
  home = "/Users/${config.mySystem.primaryUser}";
};
```

### 3. Home Manager Integration

**Two integration approaches:**

#### A. NixOS Module Approach (north, minibook)

```nix
# In flake.nix
home-manager.nixosModules.home-manager
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "bak";
  home-manager.users.ermyril = {
    imports = [ ./home-manager/default.nix ... ];
  };
}
```

#### B. Darwin Module Approach (macbook)

```nix
# In flake.nix
home-manager.darwinModules.home-manager
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  # ... same pattern
}
```

**Settings:**
- `useGlobalPkgs = true`: Home-manager uses system nixpkgs
- `useUserPackages = true`: Packages installed to user profile
- `backupFileExtension = "bak"`: Backup existing files on conflict

### 4. Comprehensive Module Pattern

**Best practice for new modules** (see reaper.nix):

```nix
{ config, lib, pkgs, ... }:
with lib;
let cfg = config.mySystem.moduleName;
in {
  options.mySystem.moduleName = {
    enable = mkEnableOption "Module description";
    # ... additional options
  };

  config = mkIf cfg.enable {
    # 1. System services
    services.foo = { ... };

    # 2. System packages
    environment.systemPackages = [ ... ];

    # 3. User groups
    users.users.${config.mySystem.primaryUser}.extraGroups = [ ... ];

    # 4. Home-manager config for primary user
    home-manager.users.${config.mySystem.primaryUser} = {
      home.packages = [ ... ];
      home.sessionVariables = { ... };
    };

    # 5. System-wide settings
    security.pam.loginLimits = [ ... ];
  };
}
```

**Benefits:**
- Everything in one place
- Easy to enable/disable
- No scattered dependencies
- References primary user correctly

### 5. Stylix Theming

**Centralized theming** via `home-manager/modules/stylix.nix`:

```nix
stylix = {
  enable = true;
  base16Scheme = "catppuccin-mocha.yaml";
  image = ./../../wallpapers/ark.jpg;
  polarity = "dark";

  fonts = {
    monospace = { package = ...; name = "FiraCode Nerd Font Mono"; };
    # ...
  };

  targets = {
    kitty.enable = true;
    tmux.enable = true;
    vim.enable = true;
    fish.enable = true;
    fzf.enable = true;
  };
};
```

**Applied to:** All home-manager configurations via imports

---

## Current State & Issues

### Working Well ✅

1. **Modular system configuration** - Easy to enable/disable features
2. **Cross-platform support** - Shared modules work on Linux and macOS
3. **Consistent theming** - Stylix provides unified look
4. **Professional audio setup** - PipeWire with JACK support working correctly
5. **Git integration** - All nix files tracked and must be in index

### Known Issues ⚠️

1. **Inconsistent home-manager imports**
   - `north` imports `platforms/linux.nix` → gets full Linux config
   - `minibook` does NOT import `platforms/linux.nix` → missing features
   - **Impact:** minibook missing GNOME extensions, some packages
   - **Fix:** Add `./home-manager/platforms/linux.nix` to minibook HM imports

2. **Module organization inconsistency**
   - `north` uses mostly flake-level modules
   - `minibook` uses many host-local module files
   - **Impact:** Configuration scattered, harder to maintain
   - **Fix:** Move minibook's local modules to shared/nixos as appropriate

3. **Commented-out modules**
   - `hyprland.nix` exists but not used on any host
   - `syncthing.nix` marked "do not enable"
   - **Impact:** Dead code, unclear if intentional
   - **Fix:** Remove or document why disabled

4. **Package duplication**
   - Some packages appear in both system and HM configs
   - Example: kitty in `modules/shared/packages/common.nix` (system) and used via HM
   - **Impact:** Potential conflicts, wasted disk space
   - **Fix:** Decide on system vs. user-level for each package

5. **Deprecated home-manager options**
   - Evaluation warnings about `programs.git.userName` → `programs.git.settings.user.name`
   - `nixpkgs.config` with `useGlobalPkgs` warning
   - **Impact:** Will break in future home-manager versions
   - **Fix:** Update to new option names

6. **macOS nix daemon disabled**
   - `nix.enable = false` in macbook config
   - **Impact:** Unclear if this is correct or workaround
   - **Fix:** Verify this is intentional for nix-darwin

### Recent Fixes 🔧

**2025-11-09:** JACK service startup failure
- **Problem:** Native JACK daemon conflicting with PipeWire
- **Solution:** Switched to PipeWire's JACK implementation
- **File:** `modules/nixos/reaper.nix`
- **Details:** See `.claude/session_log.md`

---

## Refactoring Considerations

### Short-term Improvements

1. **Fix minibook home-manager imports**
   ```nix
   # In flake.nix, minibook home-manager config
   home-manager.users.ermyril = {
     imports = [
       ./home-manager/default.nix
       ./home-manager/platforms/linux.nix  # ADD THIS
       stylix.homeModules.stylix
     ];
   };
   ```

2. **Consolidate minibook modules**
   - Move `minibook/packages.nix` → `modules/nixos/packages.nix` (merge)
   - Move `minibook/minibook.nix` → `modules/nixos/minibook-hardware.nix`
   - Keep host-specific: hardware-configuration.nix, cron.nix, vars.nix

3. **Update deprecated options**
   ```nix
   # In home-manager/modules/linux.nix
   programs.git.settings = {
     user.name = "Er Myril";
     user.email = "ermyril@gmail.com";
     # Move other extraConfig here
   };
   ```

4. **Remove dead code**
   - Delete unused dotfiles in `dotfiles/config/`
   - Archive or remove disabled modules (syncthing, etc.)

### Long-term Refactoring

1. **Standardize module structure**
   - All feature modules use `mySystem.feature.enable` pattern
   - All feature modules in `modules/nixos/` or `modules/darwin/`
   - Host configs only import features + hardware config

2. **Create feature categories**
   ```
   modules/nixos/
   ├── desktop/
   │   ├── gnome.nix
   │   ├── cosmic.nix
   │   └── hyprland.nix
   ├── creative/
   │   ├── reaper.nix
   │   └── video-production.nix
   ├── services/
   │   └── deluge.nix
   └── hardware/
       └── nvidia.nix
   ```

3. **Extract host-specific patterns**
   - Create `modules/nixos/hardware/convertible.nix` for minibook
   - Create `modules/nixos/hardware/nvidia.nix` for north
   - Hosts just enable: `mySystem.hardware.nvidia.enable = true`

4. **Unify package management**
   - Document system vs. HM package policy
   - System: Services, daemons, system utilities
   - HM: User applications, dev tools, GUI apps

5. **Create overlays module**
   - Centralize all nixpkgs overlays
   - Currently scattered (NUR in flake, fcitx in linux.nix)

### Testing Strategy

When refactoring:

1. **Use `nixos-rebuild test`** - Non-persistent, quick iteration
2. **Git branch per change** - Easy rollback
3. **Test on minibook first** - Simpler config, less critical
4. **Verify both hosts work** - Before committing
5. **Document in commit messages** - Reference this doc

---

## Quick Reference

### Common Commands

```bash
# NixOS hosts
sudo nixos-rebuild test --flake .#north
sudo nixos-rebuild switch --flake .#north
sudo nixos-rebuild test --flake .#minibook

# macOS host
darwin-rebuild switch --flake .#macbook

# Home manager standalone (if needed)
home-manager switch --flake .#ermyril@north

# Update flake inputs
nix flake update

# Check flake
nix flake check
```

### Important Paths

```
System config:     /run/current-system/configuration.nix
Home manager:      ~/.config/home-manager/
Nix store:         /nix/store/
User profile:      ~/.nix-profile/
```

### Key Files to Check When...

**Adding new module:**
- Review `modules/nixos/reaper.nix` for pattern
- Update this document's module list

**Changing primary user:**
- `modules/shared/users.nix` (option definition)
- `hosts/*/configuration.nix` (set value)

**Adding new host:**
- Create `hosts/newhost/`
- Add to `flake.nix` outputs
- Reference shared modules

**Theming changes:**
- `home-manager/modules/stylix.nix`
- `wallpapers/` for background images

---

## Version History

| Date | Changes |
|------|---------|
| 2025-11-09 | Initial architecture documentation created |
| 2025-11-09 | JACK service fix - switched to PipeWire implementation |

---

**Note:** This document should be updated whenever significant architectural changes are made. Use `.claude/session_log.md` for session-specific debugging notes.
