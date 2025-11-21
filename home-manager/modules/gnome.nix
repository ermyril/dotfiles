{ config, lib, pkgs, ... }:

with lib;

{
  options.myHome.gnome.enable = mkEnableOption "GNOME desktop environment configuration";

  config = mkIf config.myHome.gnome.enable {
    # Import GNOME-specific dconf settings
    imports = [
      ./dconf.nix
    ];

    # GNOME-specific packages
    home.packages = with pkgs; [
      gnome-tweaks
      dconf-editor
      gnomeExtensions.pop-shell
      gnomeExtensions.dash-to-dock
      gnomeExtensions.hide-top-bar
      gnomeExtensions.gjs-osk
      gnomeExtensions.screen-rotate
      dconf2nix  # to generate nixconfig from dconf
    ];
  };
}
