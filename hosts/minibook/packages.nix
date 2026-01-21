{ config, pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    vim-full
    wget
    firefox
    # bookworm  # Marked as broken in nixpkgs
    calibre
    telegram-desktop
    kitty
    neofetch
    htop
    tmux
    home-manager
    wine

    git
    git-credential-manager
    pass-git-helper
    msmtp

    acpid
    wl-clipboard
    #nerd-fonts

    emacs
    ripgrep
    clang
    cmake
    nixfmt-classic
    python3
    emacsPackages.vterm
    emacsPackages.python

    gnome-tweaks
    dconf-editor
    gnomeExtensions.pop-shell
    gnomeExtensions.dash-to-dock
    gnomeExtensions.hide-top-bar
    gnomeExtensions.gjs-osk
    gnomeExtensions.screen-rotate

    gimp
  ];

}


