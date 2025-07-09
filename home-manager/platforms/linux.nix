{ config, ... }:
{
  # Linux platform configuration
  imports = [
    ../modules/linux.nix
  ];

  # Linux-specific home directory
  home.homeDirectory = "/home/${config.home.username}";
}