{ pkgs, ... }:
{
  # Aggregate all feature modules previously referenced by flake-based HM
  imports = [
    ./home.nix                           # base user/home options
    ./.config/home-manager/tmux.nix
    ./.config/home-manager/vim.nix
    ./.config/home-manager/dconf.nix
    # ./.config/home-manager/emacs.nix    # uncomment when needed
    # ./.config/home-manager/kmonad.nix   # linux-only if desired
    ./.config/home-manager/dotfiles.nix
    ./.config/home-manager/ssh.nix
    ./.config/home-manager/fish.nix
    ./.config/home-manager/firefox.nix
    ./.config/home-manager/syncthing.nix
    ./.config/home-manager/linux.nix     # platform-specific tweaks
    # ./.config/home-manager/macos.nix   # keep for macbook standalone HM
  ];

  home.username      = "ermyril";
  home.homeDirectory = "/home/ermyril";
  home.stateVersion  = "25.05";

  programs.home-manager.enable = true;

  home.packages = [
    pkgs.nixpkgs-fmt
  ];
}
