{ config, ... }:
{
  # macOS platform configuration
  imports = [
    ../modules/macos/macos.nix
  ];

  # macOS-specific home directory
  home.homeDirectory = "/Users/${config.home.username}";
}