{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
    /home/ermyril/.dotfiles/.config/home-manager/linux.nix
  ];

  home-manager.users.ermyril = {
    home.stateVersion = "23.11";
  };
}
