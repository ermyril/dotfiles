{ pkgs, ... }:

{
  # Development tools that should be available system-wide
  environment.systemPackages = with pkgs; [
    # Build tools
    cmake
    clang
    
    # Version control
    git
    
    # Text processing
    ripgrep
    
    # Formatters
    nixfmt-classic
    
    # Language servers and tools
    gopls
  ];
}