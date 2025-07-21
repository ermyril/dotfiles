{ config, lib, pkgs, ... }:

{
  # Stylix configuration at home-manager level
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    image = ./../../wallpapers/ark.jpg;

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
    targets.firefox.profileNames = [ "ermyril" ];
    # targets = {
    #   kitty.enable = true;
    #   tmux.enable = true;  
    #   vim.enable = true;
    #   console.enable = true;
    #   fish.enable = true;
    #   fzf.enable = true;
    # };
  };
}
