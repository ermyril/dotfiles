{ pkgs, ... }:

{
  # macOS-specific system packages
  environment.systemPackages = with pkgs; [
    # Window management (macOS-specific)
    yabai
    skhd
  ];
}