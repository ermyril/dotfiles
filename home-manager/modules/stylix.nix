{ config, lib, pkgs, ... }:

{
  # Stylix configuration at home-manager level
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    
    image = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/wallpapers/nix-wallpaper-nineish-dark-gray.png";
      sha256 = "sha256-nhIUtCy/Hf9O4flOOiyzUUV1AESeVYncr8qiU5OwpN4=";
    };

    polarity = "dark";
    
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.fira;
        name = "Fira Sans";
      };
      serif = {
        package = pkgs.fira;
        name = "Fira Sans";
      };
      sizes = {
        applications = 12;
        terminal = 14;
        desktop = 12;
        popups = 12;
      };
    };

    # Enable targets for kitty and vim, but disable tmux (using custom Catppuccin)
    targets = {
      kitty.enable = true;
      tmux.enable = false;  # Disabled - using custom Catppuccin configuration
      vim.enable = true;
    };
  };
}