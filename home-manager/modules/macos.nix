{ config, pkgs, ... }:

let
  # Set the username and home directory using environment variables
  username = builtins.getEnv "USERNAME";
  homeDir = builtins.getEnv "HOME";
in {
  home.username = "mikhaini";
  home.homeDirectory = "/Users/mikhaini";

    imports = [
        ./dotfiles.nix
        ./tmux.nix
        ./fish.nix
        ./vim.nix
        ./ssh.nix
        ./home-manager-spotlight-hack.nix
   ];

  home.packages = with pkgs; [
    docker
    kubectl
    kitty
    neofetch
    git
    coreutils
    gnused
    gnugrep
    gnupg
    ansible
    yabai 
    skhd 
    netcat 
    htop
    go

    emacs29-macport # TODO: move to the separate file
    emacsPackages.vterm
    haskell-language-server
    ghc
    gopls
    libgccjit

    fd
    jq
    yq-go
    awscli2
    ripgrep
    #lima # try to update it after some time, right now there is some troubles with VZ vm's
    cmake
    terraform
    minikube
    #parallel
    multimarkdown
    postgresql_14
    fnm
    nerdfonts
    podman

    mongodb
    nixpkgs-fmt  # Nix formatter

    # (python3.withPackages (ps: with ps; [
    #   ipykernel jupyterlab
    #   matplotlib numpy pandas seaborn
    #   networkx
    # ]))
  ];


  home.stateVersion = "23.11";
  nixpkgs.config.allowUnfree = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.enableNixpkgsReleaseCheck = false;
}
