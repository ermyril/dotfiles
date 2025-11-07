{
  # Plain text configuration files - now organized in dedicated dotfiles/ directory
  
  # Terminal & GUI apps
  # kitty is now managed by programs.kitty in kitty.nix
  
  # macOS window managers
  #home.file.".yabairc".source = ../../dotfiles/yabairc;
  #home.file.".skhdrc".source = ../../dotfiles/skhdrc;
  
  # Editors
  home.file.".doom.d".source = ../../dotfiles/doom.d;
  
  # Git
  home.file.".gitignore_global".source = ../../dotfiles/gitignore_global;
}
