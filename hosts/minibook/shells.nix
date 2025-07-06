{ config, pkgs, lib, ... }:
{
  users.defaultUserShell = pkgs.fish;
  programs.zsh.enable = false;
  programs.zsh.histSize = 50000;
  programs.fish.enable = true;
  programs.fish.interactiveShellInit = "
    set -g fish_greeting ''
    alias nix-shell='nix-shell --run fish'
    alias ,='nix-shell -p'
  ";
  environment.shells = with pkgs; [ fish zsh bash ];
}
