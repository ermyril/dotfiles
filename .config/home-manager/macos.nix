{ config, pkgs, ... }:

{
    imports = [
        ./dotfiles.nix
        ./tmux.nix
        ./fish.nix
        #./wireguard.nix
        #./outline.nix
   ];
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "nikitami";
  home.homeDirectory = "/Users/nikitami";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Packages to install
  home.packages = [
    pkgs.tmux

    pkgs.vim
    pkgs.ripgrep

    pkgs.neofetch
    pkgs.git
    pkgs.coreutils
    pkgs.fd
    pkgs.gnupg
    #pkgs.ansible
    #pkgs.yabai # shit is not working due to plist fuckery in home-manager
    #pkgs.skhd # same as above
  ];

}
