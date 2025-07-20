{ pkgs, ... }:

{
  # Linux-specific system packages
  environment.systemPackages = with pkgs; [
    # Linux-specific system tools
    acpid
    wl-clipboard
    
    # Graphics/Gaming (Linux-specific)
    mesa-demos
    vulkan-tools
    clinfo
    
    # Desktop environment tools
    gnome-tweaks
    dconf-editor
    
    # System utilities
    systemd
    
    # Audio/Video
    pulseaudio
    
    # Network tools
    networkmanager

    android-tools # move to obs setup
    usbmuxd #move to obs setup
  ];
}
