{ pkgs, ... }:
{
  # Aggregate all feature modules previously referenced by flake-based HM
  imports = [
    ./modules/tmux.nix
    ./modules/vim.nix
    ./modules/dotfiles.nix
    ./modules/ssh.nix
    ./modules/fish.nix
    ./modules/firefox.nix
    #./modules/syncthing.nix # do not enable
  ];

  # username and homeDirectory are set by the flake
  home.stateVersion  = "25.05";

  programs.home-manager.enable = true;

}
