{ pkgs, ... }:

{
  # Cross-platform system packages
  environment.systemPackages = with pkgs; [
    # Essential system utilities
    vim
    wget
    git
    curl
    htop
    
    # Terminal emulator
    kitty
    
    # Development tools (system-level)
    python3
    
    # System monitoring
    neofetch
    
    # Archive tools
    unzip
    p7zip
    
    # Network tools
    netcat
    
    # File utilities
    fd
  ];
}