# Configuration Refactoring TODO List

**Created:** 2025-11-09
**Purpose:** Comprehensive plan for improving modularity, consolidating minibook config, and moving appropriate configs from home-manager to system level

**References:**
- `.claude/ARCHITECTURE.md` - Current architecture documentation
- `CLAUDE.md` - Project instructions and philosophy

---

## Table of Contents

1. [Priority Overview](#priority-overview)
2. [Phase 1: Critical Fixes](#phase-1-critical-fixes)
3. [Phase 2: Minibook Refactoring](#phase-2-minibook-refactoring)
4. [Phase 3: System vs Home-Manager Reorganization](#phase-3-system-vs-home-manager-reorganization)
5. [Phase 4: Module Structure Improvements](#phase-4-module-structure-improvements)
6. [Phase 5: Advanced Modularization](#phase-5-advanced-modularization)
6. [Testing Checklist](#testing-checklist)

---

## Priority Overview

| Priority | Phase | Description | Risk Level |
|----------|-------|-------------|------------|
| 🔴 P0 | Phase 1 | Critical fixes (minibook HM, deprecated options) | Low |
| 🟠 P1 | Phase 2 | Minibook module consolidation | Medium |
| 🟡 P2 | Phase 3 | System/HM reorganization | Medium |
| 🟢 P3 | Phase 4 | Module structure improvements | Low |
| 🔵 P4 | Phase 5 | Advanced modularization | Low |

---

## Phase 1: Critical Fixes

**Goal:** Fix immediate issues that cause warnings or missing functionality
**Priority:** 🔴 P0 - Do these first
**Estimated Time:** 1-2 hours

### 1.1 Fix Minibook Home-Manager Imports

**Issue:** minibook doesn't import `platforms/linux.nix`, missing GNOME extensions and Linux tools

**Location:** `flake.nix` line 111-119

**Task:**
- [ ] Add `./home-manager/platforms/linux.nix` to minibook's home-manager imports
- [ ] Verify imports match north's configuration
- [ ] Test rebuild on minibook
- [ ] Verify GNOME extensions appear

**Changes:**
```nix
# In flake.nix, minibook section
home-manager.users.ermyril = {
  imports = [
    ./home-manager/default.nix
    ./home-manager/platforms/linux.nix  # ADD THIS LINE
    stylix.homeModules.stylix
  ];
  home.stateVersion = "22.11";
};
```

**Success Criteria:** minibook gets same HM config as north

---

### 1.2 Update Deprecated Home-Manager Options

**Issue:** Warnings about `programs.git.userName` → `programs.git.settings.user.name`

**Location:** `home-manager/modules/linux.nix` lines 87-102

**Task:**
- [ ] Update git configuration to use new option names
- [ ] Move `extraConfig` to `settings`
- [ ] Test on both north and minibook
- [ ] Verify git still works correctly

**Changes:**
```nix
# In home-manager/modules/linux.nix
programs.git = {
  enable = true;
  settings = {
    user = {
      name = "Er Myril";
      email = "ermyril@gmail.com";
    };
    # signing = {  # Uncomment when ready
    #   key = "0FBCD3EE63107407";
    #   signByDefault = true;
    # };
    lfs.enable = true;
    pull = {
      ff = "only";
      rebase = true;
    };
    init.defaultBranch = "master";
    credential.helper = "${pkgs.pass-git-helper}/bin/pass-git-helper";
  };
};
```

**Success Criteria:** No more evaluation warnings about git options

---

### 1.3 Address nixpkgs.config Warning

**Issue:** Warning about using `nixpkgs.config` with `useGlobalPkgs`

**Location:** `home-manager/modules/linux.nix` line 111-115

**Task:**
- [ ] Review if fcitx overlay is still needed
- [ ] If needed, move to system-level overlays
- [ ] If not, remove the overlay entirely
- [ ] Test on both hosts

**Current code:**
```nix
# home-manager/modules/linux.nix
nixpkgs.overlays = [
  (self: super: {
    fcitx-engines = pkgs.fcitx5;
  })
];
```

**Options:**
1. Remove if not used (check with `nix-store --query --referrers /nix/store/*fcitx*`)
2. Move to flake.nix overlays if needed

**Success Criteria:** No warning about nixpkgs.config

---

## Phase 2: Minibook Refactoring

**Goal:** Consolidate minibook's scattered modules into proper shared/nixos modules
**Priority:** 🟠 P1
**Estimated Time:** 3-4 hours

### Overview

Minibook currently has 15 local .nix files. Many can be consolidated, moved to shared modules, or eliminated.

**Current minibook local modules:**
```
hosts/minibook/
├── configuration.nix      # Keep - main config
├── hardware-configuration.nix  # Keep - auto-generated
├── minibook.nix          # Move to modules/nixos/hardware/convertible.nix
├── packages.nix          # Merge into modules/nixos/packages.nix or HM
├── gc.nix                # Already in shared/nix-settings.nix - DELETE
├── shells.nix            # Redundant with shared/users.nix - DELETE
├── nur.nix               # Already in flake - DELETE
├── xserver.nix           # Inline into configuration.nix
├── vars.nix              # Move to shared module or inline
├── filesystems.nix       # Keep in host (hardware-specific)
├── home-encryption.nix   # Keep in host (hardware-specific)
├── cron.nix              # Keep in host (host-specific schedule)
├── syncthing.nix         # Keep but review if used
├── wireguard.nix         # Keep in host (host-specific VPN)
├── home-manager.nix      # DELETE - not used (managed in flake)
└── programs/
    ├── kmonad/kmonad.nix # Move to modules/nixos/programs/kmonad.nix
    └── waydroid.nix      # Move to modules/nixos/programs/waydroid.nix
```

---

### 2.1 Delete Redundant Modules

**Files to delete:**
- [ ] `hosts/minibook/gc.nix` - Already handled in `modules/shared/nix-settings.nix`
- [ ] `hosts/minibook/nur.nix` - NUR handled in flake.nix
- [ ] `hosts/minibook/shells.nix` - Shell config in `modules/shared/users.nix`
- [ ] `hosts/minibook/home-manager.nix` - Not used (managed in flake)

**Task:**
- [ ] Remove imports from `hosts/minibook/configuration.nix`
- [ ] Delete the files
- [ ] Test rebuild

**Success Criteria:** Minibook still builds without these files

---

### 2.2 Inline Simple Configs

**xserver.nix** (6 lines) - inline into configuration.nix

**Task:**
- [ ] Move xserver settings to `hosts/minibook/configuration.nix`
- [ ] Delete `hosts/minibook/xserver.nix`
- [ ] Remove import

**Add to configuration.nix:**
```nix
services.xserver.autoRepeatDelay = 200;
services.xserver.autoRepeatInterval = 30;
```

**vars.nix** (15 lines) - evaluate if needed, inline if keeping

**Task:**
- [ ] Check if XDG variables are necessary (usually defaults work)
- [ ] If needed, inline into configuration.nix
- [ ] Otherwise delete

---

### 2.3 Create Convertible Hardware Module

**Source:** `hosts/minibook/minibook.nix`
**Target:** `modules/nixos/hardware/convertible.nix`

**Task:**
- [ ] Create `modules/nixos/hardware/convertible.nix`
- [ ] Add `mySystem.hardware.convertible.enable` option
- [ ] Move minibook.nix content there
- [ ] Update minibook configuration.nix to use new module
- [ ] Add module to flake imports for minibook
- [ ] Test rebuild

**New module structure:**
```nix
# modules/nixos/hardware/convertible.nix
{ config, lib, pkgs, ... }:
with lib;
let cfg = config.mySystem.hardware.convertible;
in {
  options.mySystem.hardware.convertible = {
    enable = mkEnableOption "Convertible laptop hardware support";

    rotation = mkOption {
      type = types.enum [ "normal" "left" "right" "inverted" ];
      default = "right";
      description = "Display rotation";
    };

    displayConnector = mkOption {
      type = types.str;
      default = "DSI-1";
      description = "Display connector name";
    };

    # ... other options
  };

  config = mkIf cfg.enable {
    # Content from minibook.nix
    boot.kernelParams = [ "fbcon=rotate:1" ];
    hardware.sensor.iio.enable = true;

    environment.systemPackages = with pkgs; [
      libinput
      iio-sensor-proxy
      lm_sensors
      auto-cpufreq
      i2c-tools
    ];

    # TPM support
    security.tpm2 = {
      enable = true;
      pkcs11.enable = true;
      tctiEnvironment.enable = true;
    };

    # Chassis type
    environment.etc.machine-info = {
      text = "CHASSIS=convertible";
      mode = "0440";
    };

    users.users.${config.mySystem.primaryUser}.extraGroups = [ "tss" ];

    # GDM monitor rotation config (parameterized)
    systemd.tmpfiles.rules = [
      # ... rotation config using cfg.rotation and cfg.displayConnector
    ];
  };
}
```

**Success Criteria:** Minibook enables with `mySystem.hardware.convertible.enable = true;`

---

### 2.4 Extract KMonad Module

**Source:** `hosts/minibook/programs/kmonad/kmonad.nix`
**Target:** `modules/nixos/programs/kmonad.nix`

**Task:**
- [ ] Create `modules/nixos/programs/kmonad.nix`
- [ ] Add `mySystem.programs.kmonad.enable` option
- [ ] Add `mySystem.programs.kmonad.configFile` option
- [ ] Move kmonad setup from minibook
- [ ] Update minibook to use new module
- [ ] Keep config files in `hosts/minibook/programs/kmonad/` (referenced by path)

**Module structure:**
```nix
# modules/nixos/programs/kmonad.nix
{ config, lib, pkgs, inputs, ... }:
with lib;
let cfg = config.mySystem.programs.kmonad;
in {
  options.mySystem.programs.kmonad = {
    enable = mkEnableOption "KMonad keyboard remapping";

    configFile = mkOption {
      type = types.path;
      description = "Path to kmonad configuration file";
    };
  };

  config = mkIf cfg.enable {
    # Import kmonad from flake inputs
    imports = [ inputs.kmonad.nixosModules.default ];

    services.kmonad = {
      enable = true;
      keyboards.default = {
        device = "/dev/input/by-path/...";  # make configurable
        config = builtins.readFile cfg.configFile;
      };
    };

    users.users.${config.mySystem.primaryUser}.extraGroups = [ "input" "uinput" ];
  };
}
```

**Success Criteria:** KMonad works on minibook with module enabled

---

### 2.5 Extract Waydroid Module

**Source:** `hosts/minibook/programs/waydroid.nix`
**Target:** `modules/nixos/programs/waydroid.nix`

**Task:**
- [ ] Create `modules/nixos/programs/waydroid.nix`
- [ ] Add `mySystem.programs.waydroid.enable` option
- [ ] Move waydroid config from minibook
- [ ] Update minibook to use new module

---

### 2.6 Reorganize Minibook Packages

**Current:** `hosts/minibook/packages.nix` has mix of system and user packages

**Strategy:** Split packages by purpose

**Task:**
- [ ] Identify which packages are truly minibook-specific
- [ ] Move general Linux packages to `modules/nixos/packages.nix`
- [ ] Move user packages to home-manager (see Phase 3)
- [ ] Keep only minibook-specific packages in host

**Analysis of packages.nix:**

| Package | Category | Destination |
|---------|----------|-------------|
| vim-full, wget, git | Basic utils | Already in shared/common |
| firefox | Browser | Already in HM |
| calibre | E-books | HM (user app) |
| telegram-desktop | Communication | HM (user app) |
| kitty | Terminal | Already in shared/common |
| neofetch, htop, tmux | Utils | Already in HM |
| home-manager | System | Already in flake |
| wine | Compatibility | modules/nixos/packages.nix |
| git-credential-manager, pass-git-helper | Git | HM (per-user) |
| acpid, wl-clipboard | System | modules/nixos/packages.nix |
| emacs + packages | Editor | Already in HM/emacs.nix |
| gnome-tweaks, extensions | Desktop | HM linux.nix |
| obs-studio + plugins | Media | Create modules/nixos/obs.nix |
| gimp | Graphics | HM (user app) |

**Result:** minibook/packages.nix should be nearly empty or deleted

---

### 2.7 Update Minibook configuration.nix

**Goal:** Clean main config file to only reference modules

**Task:**
- [ ] Remove all deleted module imports
- [ ] Add new module imports from flake
- [ ] Inline simple configs (xserver, vars if keeping)
- [ ] Keep only truly host-specific configs

**Target structure:**
```nix
# hosts/minibook/configuration.nix
{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./filesystems.nix          # Hardware-specific
    ./home-encryption.nix      # Hardware-specific
    ./cron.nix                 # Host-specific
    ./wireguard.nix            # Host-specific VPN config
    # ./syncthing.nix          # Review if needed
  ];

  # Primary user
  mySystem.primaryUser = "ermyril";

  # Feature modules (enabled via flake imports)
  mySystem.deluge.enable = true;
  mySystem.reaper.enable = true;
  mySystem.hardware.convertible.enable = true;
  mySystem.programs.kmonad = {
    enable = true;
    configFile = ./programs/kmonad/config.kbd;
  };
  mySystem.programs.waydroid.enable = true;

  # Hardware
  hardware.sensor.iio.enable = true;

  # Boot
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    enableCryptodisk = true;
  };
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Network
  networking.firewall.checkReversePath = false;
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  networking.firewall.allowedUDPPorts = [ 67 69 80 443 ];

  # Time
  time.timeZone = "Europe/Prague";

  # Display
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.xserver.autoRepeatDelay = 200;
  services.xserver.autoRepeatInterval = 30;

  # Users
  users.users.ermyril = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
  };
  security.sudo.wheelNeedsPassword = false;

  # Virtualization
  virtualisation.docker.enable = true;

  # Memory
  zramSwap.enable = true;

  # Licensing
  nixpkgs.config.nvidia.acceptLicense = true;

  system.stateVersion = "23.11";
}
```

**Success Criteria:** Clean, minimal configuration.nix that references modules

---

## Phase 3: System vs Home-Manager Reorganization

**Goal:** Move appropriate configs from home-manager to system level
**Priority:** 🟡 P2
**Estimated Time:** 2-3 hours

### 3.1 Define Package Policy

**Create documentation** for when to use system vs HM packages

**Task:**
- [ ] Document policy in ARCHITECTURE.md
- [ ] Create decision tree for package placement

**Policy:**

| Package Type | Location | Reason | Examples |
|-------------|----------|--------|----------|
| System services | System | Need systemd units | deluge, syncthing, nginx |
| System daemons | System | Run as system user | cups, avahi |
| CLI utilities | System | Available to all users | vim, git, curl, htop |
| Desktop environments | System | System-wide config | gnome, cosmic, plasma |
| Window managers | System | System integration | hyprland, i3 |
| Hardware drivers | System | Kernel modules | nvidia, mesa, vulkan |
| Development tools | HM | Per-user versions | nodejs, python, rust |
| GUI applications | HM | User preferences | firefox, gimp, vscode |
| User services | HM | Per-user systemd | syncthing (user) |
| Dotfile configs | HM | Per-user settings | tmux, vim, fish |
| Fonts (theming) | HM | Per-user fonts | nerd-fonts via stylix |
| Fonts (system) | System | Fallback fonts | noto-fonts |

---

### 3.2 Move System Utilities to System Level

**Packages to move from HM to system:**

From `home-manager/default.nix`:
- [ ] git → shared/packages/common.nix (if not already)
- [ ] curl, wget → shared/packages/common.nix
- [ ] htop, btop → shared/packages/common.nix
- [ ] coreutils, netcat, fd → shared/packages/common.nix

From `home-manager/modules/linux.nix`:
- [ ] gnome-tweaks, dconf-editor → modules/nixos/packages.nix
- [ ] wireshark → modules/nixos/packages.nix (needs system groups)
- [ ] gparted → modules/nixos/packages.nix (needs root)
- [ ] atop → modules/nixos/packages.nix (system monitoring)

**Success Criteria:** Base utilities available system-wide

---

### 3.3 Create GNOME Desktop Module

**Current:** GNOME packages scattered in HM and system configs

**Goal:** Consolidate GNOME desktop configuration

**Task:**
- [ ] Create `modules/nixos/desktop/gnome.nix`
- [ ] Move GNOME packages from HM to module
- [ ] Add `mySystem.desktop.gnome.enable` option
- [ ] Include common GNOME extensions as options

**Module structure:**
```nix
# modules/nixos/desktop/gnome.nix
{ config, lib, pkgs, ... }:
with lib;
let cfg = config.mySystem.desktop.gnome;
in {
  options.mySystem.desktop.gnome = {
    enable = mkEnableOption "GNOME Desktop Environment";

    extensions = {
      popShell = mkEnableOption "Pop Shell tiling" // { default = true; };
      dashToDock = mkEnableOption "Dash to Dock" // { default = true; };
      hideTopBar = mkEnableOption "Hide Top Bar" // { default = false; };
    };
  };

  config = mkIf cfg.enable {
    services.xserver.enable = true;
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    environment.systemPackages = with pkgs; [
      gnome-tweaks
      dconf-editor
    ] ++ optionals cfg.extensions.popShell [ gnomeExtensions.pop-shell ]
      ++ optionals cfg.extensions.dashToDock [ gnomeExtensions.dash-to-dock ]
      ++ optionals cfg.extensions.hideTopBar [ gnomeExtensions.hide-top-bar ];

    # Exclude default GNOME apps if desired
    environment.gnome.excludePackages = with pkgs; [
      gnome-tour
      # Add others as needed
    ];
  };
}
```

**Success Criteria:** GNOME desktop enabled with `mySystem.desktop.gnome.enable = true;`

---

### 3.4 Create OBS Studio Module

**Current:** OBS configured in minibook/packages.nix and north/configuration.nix

**Task:**
- [ ] Create `modules/nixos/creative/obs-studio.nix`
- [ ] Add `mySystem.creative.obs.enable` option
- [ ] Add plugin options
- [ ] Move OBS configs from both hosts

**Module structure:**
```nix
# modules/nixos/creative/obs-studio.nix
{ config, lib, pkgs, ... }:
with lib;
let cfg = config.mySystem.creative.obs;
in {
  options.mySystem.creative.obs = {
    enable = mkEnableOption "OBS Studio with plugins";

    cudaSupport = mkOption {
      type = types.bool;
      default = false;
      description = "Enable NVIDIA CUDA support";
    };

    plugins = {
      backgroundRemoval = mkEnableOption "Background removal" // { default = true; };
      pipewireAudio = mkEnableOption "PipeWire audio capture" // { default = true; };
      wlrobs = mkEnableOption "wlrobs (Wayland capture)" // { default = true; };
      droidcam = mkEnableOption "DroidCam OBS" // { default = false; };
      virtualCamera = mkEnableOption "Virtual camera" // { default = false; };
    };
  };

  config = mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;
      package = if cfg.cudaSupport then
        (pkgs.obs-studio.override { cudaSupport = true; })
      else
        pkgs.obs-studio;

      plugins = with pkgs.obs-studio-plugins; []
        ++ optional cfg.plugins.backgroundRemoval obs-backgroundremoval
        ++ optional cfg.plugins.pipewireAudio obs-pipewire-audio-capture
        ++ optional cfg.plugins.wlrobs wlrobs
        ++ optional cfg.plugins.droidcam droidcam-obs
        # ... add others
        ;
    };

    # Add to primary user groups
    users.users.${config.mySystem.primaryUser}.extraGroups = [ "video" ];
  };
}
```

**Success Criteria:** OBS configured via module on both hosts

---

### 3.5 Review and Clean Home-Manager Modules

**Task:**
- [ ] Review each HM module for system-level candidates
- [ ] Move system services to system modules
- [ ] Keep user-specific configs in HM
- [ ] Document remaining HM module purposes

**Modules to review:**
- [ ] `emacs.nix` - Check if packages should be system-level
- [ ] `dconf.nix` - GNOME settings (keep in HM - user preferences)
- [ ] `syncthing.nix` - Should this be system or user service?

---

## Phase 4: Module Structure Improvements

**Goal:** Improve module organization and reusability
**Priority:** 🟢 P3
**Estimated Time:** 2-3 hours

### 4.1 Reorganize Module Directory Structure

**Current:**
```
modules/
├── shared/
│   ├── nix-settings.nix
│   ├── users.nix
│   ├── keyboard.nix
│   └── packages/common.nix
├── nixos/
│   ├── packages.nix
│   ├── deluge.nix
│   ├── reaper.nix
│   └── hyprland.nix
└── darwin/
    └── packages.nix
```

**Target:**
```
modules/
├── shared/
│   ├── nix-settings.nix
│   ├── users.nix
│   ├── keyboard.nix
│   └── packages/
│       ├── common.nix
│       └── development.nix
├── nixos/
│   ├── desktop/
│   │   ├── gnome.nix
│   │   ├── cosmic.nix
│   │   └── hyprland.nix
│   ├── creative/
│   │   ├── reaper.nix
│   │   ├── obs-studio.nix
│   │   └── video-production.nix
│   ├── services/
│   │   └── deluge.nix
│   ├── programs/
│   │   ├── kmonad.nix
│   │   └── waydroid.nix
│   ├── hardware/
│   │   ├── nvidia.nix
│   │   ├── convertible.nix
│   │   └── audio.nix (extract from reaper?)
│   └── packages.nix
└── darwin/
    ├── desktop/
    └── packages.nix
```

**Task:**
- [ ] Create new directory structure
- [ ] Move existing modules to new locations
- [ ] Update all imports in flake.nix
- [ ] Test all hosts build correctly

---

### 4.2 Extract NVIDIA Module

**Source:** `hosts/north/configuration.nix` lines 116-127
**Target:** `modules/nixos/hardware/nvidia.nix`

**Task:**
- [ ] Create `modules/nixos/hardware/nvidia.nix`
- [ ] Add `mySystem.hardware.nvidia.enable` option
- [ ] Move NVIDIA config from north
- [ ] Add options for settings (powerManagement, etc.)

**Module structure:**
```nix
# modules/nixos/hardware/nvidia.nix
{ config, lib, pkgs, ... }:
with lib;
let cfg = config.mySystem.hardware.nvidia;
in {
  options.mySystem.hardware.nvidia = {
    enable = mkEnableOption "NVIDIA GPU support";

    powerManagement = mkOption {
      type = types.bool;
      default = false;
      description = "Enable NVIDIA power management (may cause issues on some systems)";
    };

    openDrivers = mkOption {
      type = types.bool;
      default = false;
      description = "Use open-source NVIDIA drivers";
    };
  };

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = cfg.powerManagement;
      powerManagement.finegrained = false;
      open = cfg.openDrivers;
      nvidiaSettings = true;
    };

    # Disable suspend services if power management disabled
    systemd.services.nvidia-suspend.enable = cfg.powerManagement;
    systemd.services.nvidia-resume.enable = cfg.powerManagement;

    # Graphics support
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
```

---

### 4.3 Create Cosmic Desktop Module

**Source:** `hosts/north/configuration.nix`
**Target:** `modules/nixos/desktop/cosmic.nix`

**Task:**
- [ ] Create `modules/nixos/desktop/cosmic.nix`
- [ ] Add `mySystem.desktop.cosmic.enable` option
- [ ] Extract Cosmic config from north

---

### 4.4 Standardize All Modules to mySystem Pattern

**Ensure all modules follow the pattern:**

**Task:**
- [ ] Review all existing modules
- [ ] Add `mySystem.*` options where missing
- [ ] Ensure all modules use `mkIf cfg.enable`
- [ ] Document options properly

**Checklist for each module:**
- [ ] Has `mySystem.*.enable` option
- [ ] Uses `mkIf cfg.enable` for config
- [ ] References `config.mySystem.primaryUser` not hardcoded user
- [ ] Has description for all options
- [ ] Includes all dependencies (packages, services, user groups)

---

## Phase 5: Advanced Modularization

**Goal:** Advanced improvements for maximum flexibility
**Priority:** 🔵 P4
**Estimated Time:** 3-5 hours

### 5.1 Create Overlays Module

**Goal:** Centralize all nixpkgs overlays in one place

**Task:**
- [ ] Create `modules/shared/overlays.nix`
- [ ] Move NUR overlay from flake to module
- [ ] Move fcitx overlay from HM to module
- [ ] Update flake to import overlays module

---

### 5.2 Extract Audio/PipeWire Module

**Goal:** Separate audio configuration from reaper module

**Rationale:** Audio setup useful beyond just Reaper

**Task:**
- [ ] Create `modules/nixos/hardware/audio.nix`
- [ ] Extract PipeWire config from reaper.nix
- [ ] Make reaper.nix depend on audio module
- [ ] Add options for different audio backends

---

### 5.3 Create Development Environment Module

**Goal:** Modular dev environment setup

**Task:**
- [ ] Create `modules/shared/development.nix`
- [ ] Add options for language toolchains (Go, Python, Rust, etc.)
- [ ] Move development packages from HM
- [ ] Make it optional per-host

---

### 5.4 Profile System

**Goal:** Create profiles for different use cases

**Task:**
- [ ] Create `profiles/` directory
- [ ] Create profiles: workstation, laptop, server, creative
- [ ] Each profile enables appropriate modules
- [ ] Hosts import profiles instead of individual modules

**Example:**
```nix
# profiles/creative-workstation.nix
{ ... }:
{
  mySystem.desktop.gnome.enable = true;
  mySystem.creative.reaper.enable = true;
  mySystem.creative.obs.enable = true;
  mySystem.hardware.nvidia.enable = true;  # Can override per host
}
```

---

## Testing Checklist

**Before each change:**
- [ ] Create git branch for the change
- [ ] Review ARCHITECTURE.md for context

**After each change:**
- [ ] Files added to git index (`git add`)
- [ ] Run `nixos-rebuild test --flake .#<host>`
- [ ] Verify expected functionality works
- [ ] Check for evaluation warnings
- [ ] Document change in session log

**Final testing:**
- [ ] All hosts build successfully
- [ ] No evaluation warnings
- [ ] All features work as expected on north
- [ ] All features work as expected on minibook
- [ ] macbook still builds (even if untested)
- [ ] Update ARCHITECTURE.md with new structure
- [ ] Commit all changes with descriptive messages

---

## Implementation Strategy

**Recommended approach:**

1. **Phase 1 first** - Get critical fixes done
   - Low risk, high value
   - Fix warnings and missing functionality

2. **Phase 2 on minibook** - Consolidate minibook
   - Test on less critical host first
   - Build confidence with refactoring

3. **Phase 3 selectively** - Move system packages
   - Do incrementally, test between changes
   - Start with clear-cut system utilities

4. **Phase 4 as needed** - Improve structure
   - Do when you need a new module
   - Gradually reorganize over time

5. **Phase 5 optional** - Advanced features
   - Only if you need the flexibility
   - Can be done piecemeal

---

## Success Metrics

**After completion:**

- [ ] Minibook configuration.nix < 100 lines
- [ ] No host-specific modules that should be shared
- [ ] All hosts use consistent module pattern
- [ ] Clear separation: system vs HM packages
- [ ] No evaluation warnings
- [ ] Documentation updated
- [ ] All features working on all hosts

---

## Notes

- Always test on minibook first (less critical)
- Keep git commits small and focused
- Update session log after each phase
- Reference ARCHITECTURE.md frequently
- Don't rush - better to do it right than fast

---

**Last Updated:** 2025-11-09
**Next Review:** After Phase 1 completion
