{ pkgs, ... }:
{
  # Aggregate all feature modules previously referenced by flake-based HM
  imports = [
    ./home.nix                           # base user/home options
    ./modules/tmux.nix
    ./modules/vim.nix
    ./modules/dconf.nix
    # ./modules/emacs.nix    # uncomment when needed
    # ./modules/kmonad.nix   # linux-only if desired
    ./modules/dotfiles.nix
    ./modules/ssh.nix
    ./modules/fish.nix
    ./modules/firefox.nix
    #./modules/syncthing.nix # do not enable
    #./modules/linux.nix     # do not enable
    # ./modules/macos.nix   # for macbook standalone HM
  ];

  home.username      = "ermyril";
  home.homeDirectory = "/home/ermyril";
  home.stateVersion  = "25.05";

  programs.home-manager.enable = true;

  home.packages = [
    pkgs.nixpkgs-fmt
  ];

}
