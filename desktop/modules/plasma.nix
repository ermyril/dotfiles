{ config, pkgs, ... }:

{
  ##########################################################################
  # KDE Plasma 6 + SDDM Wayland session                                    #
  ##########################################################################

  services.desktopManager.plasma6.enable = true;

  services.displayManager = {
    sddm.enable = true;
    sddm.wayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # Core Plasma utilities / extras
    kdePackages.discover          # Flatpak/fwupd frontend
    kdePackages.kcalc             # Calculator
    kdePackages.kcharselect       # Special‑character picker
    kdePackages.kcolorchooser     # Simple colour picker
    kdePackages.kolourpaint       # Paint‑style image editor
    kdePackages.ksystemlog        # Log viewer
    kdePackages.sddm-kcm          # SDDM settings module

    # Power‑user & maintenance tools
    kdiff3                        # 2‑/3‑way diff/merge
    kdePackages.partitionmanager  # GUI partition tool
    hardinfo2                     # System info / benchmarks

    # Media & Wayland helpers
    haruna                        # Qt/mpv video player
    wayland-utils                 # Wayland debug utils
    wl-clipboard                  # Clipboard CLI for Wayland
  ];
}

