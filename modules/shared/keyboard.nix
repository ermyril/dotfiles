{ config, lib, pkgs, ... }:

{
  # System-level keyboard configuration for NixOS
  # This module provides XKB configuration that works at the system level
  # and is inherited by TTY, X11, and Wayland sessions
  
  # XKB configuration for X11 (and inherited by Wayland compositors)
  services.xserver.xkb = {
    layout = "us,ru";
    options = "caps:escape,grp:win_space_toggle";
  };

  # Console keyboard configuration (TTY)
  console = {
    useXkbConfig = true; # Inherit XKB options in TTY (keyMap auto-generated)
  };

  # Optional: Set environment variables for consistency
  environment.variables = {
    XKB_DEFAULT_LAYOUT = "us,ru";
    XKB_DEFAULT_OPTIONS = "caps:escape,grp:win_space_toggle";
  };

  # Optional: Install useful keyboard-related packages
  environment.systemPackages = with pkgs; [
    xorg.setxkbmap  # For manual layout switching
    xorg.xkbcomp    # For custom keyboard layouts
  ];
}