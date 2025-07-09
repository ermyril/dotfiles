{ config, pkgs, ... }:

{
  # macOS-specific imports only
  imports = [
    ./home-manager-spotlight-hack.nix
  ];

  # macOS-specific packages only
  home.packages = with pkgs; [
    # macOS-specific tools
    docker
    yabai 
    skhd 
    ansible

    # macOS-specific development
    emacs29-macport # TODO: move to the separate file
    emacsPackages.vterm
    haskell-language-server
    libgccjit

    # macOS utilities
    gnused
    gnugrep
    awscli2
    minikube
    multimarkdown
    postgresql_14
    podman
    #mongodb
  ];

  #home.enableNixpkgsReleaseCheck = false;
}
