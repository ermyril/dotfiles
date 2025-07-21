{ pkgs, ... }:
{
  imports = [
    ./modules/tmux.nix
    ./modules/vim.nix
    ./modules/dotfiles.nix
    ./modules/ssh.nix
    ./modules/fish.nix
    ./modules/firefox.nix
    ./modules/kitty.nix
    ./modules/stylix.nix
    #./modules/syncthing.nix # do not enable
  ];


  programs.home-manager.enable = true;
  # nixpkgs.config is handled by the flake

  # Common packages across all platforms
  home.packages = with pkgs; [
    # Development tools
    git
    cmake
    ripgrep
    terraform
    kubectl
    nixpkgs-fmt
    go
    gopls

    # System utilities
    neofetch
    htop
    btop
    curl
    wget
    jq
    yq-go
    unzip
    p7zip
    wireguard-tools
    coreutils
    netcat
    fd
    fnm

    # Development languages
    ghc

    # Terminal/GUI applications
    gnupg

    # Media
    ffmpeg-full
  ];

}
