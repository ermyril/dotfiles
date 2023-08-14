{
  nixpkgs,
  lib, 
  config, 
  pkgs, 
  ... 
}:
let mkTuple = lib.hm.gvariant.mkTuple;
  tools = with pkgs; [
    git
    curl
    wget
    vimgolf
    jq
    emacs
    fd # for doom-emacs
    at
    element-desktop
    ctags
    cmake
    libtool
    ripgrep
    moreutils
    gnome.gnome-tweaks
    gnome.dconf-editor
    gnomeExtensions.pop-shell
    gnomeExtensions.dash-to-dock
    wireguard-tools
    atop
    gparted
    wireshark
    dconf2nix # to generate nixconfig from dconf
    emacsPackages.vterm
    ghc
    logseq
    terraform

  ];
  apps = with pkgs; [
    ffmpeg-full
    tdesktop #telegram
    vlc
  ];
  sandbox = with pkgs; [
    spotify-tui
  ];
  username = "ermyril";
  homedir = "/home/${username}"; 
in
{
    imports = [
        ./dconf.nix # should go under the gnome module
        ./dotfiles.nix
        ./firefox.nix
        ./tmux.nix
        ./vim.nix
        ./fish.nix
        ./ssh.nix
        #./syncthing.nix
        #./wireguard.nix
        #./outline.nix
   ];
  home.stateVersion = "22.05"; 
  programs.home-manager.enable = true;
  
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  home.username = username;
  home.homeDirectory = homedir;


  home.packages =  tools ++ apps;


  #xsession.enable = true;
  #xsession.windowManager.command = "…";
  #xsession.windowManager.bspwm.enable = true;

  #fonts.fontconfig.enable = true;

  
  home.sessionVariables = {
     #fix for alacrity window decorations on gnome
     WAYLAND_DISPLAY = " " ;
     EDITOR = "vim";
  };
  programs = {
    gpg = {
      enable = true;
      mutableKeys = true;
      settings = {
    #    pinentry-program = "gnome";
      };
    };
    password-store = {
      enable = true;
      # see "man pass" 
       settings = {
        PASSWORD_STORE_DIR = "${config.home.homeDirectory}/.password-store";
        PASSWORD_STORE_KEY = "0FBCD3EE63107407";
        PASSWORD_STORE_CLIP_TIME = "60";
      };
    };

    alacritty.enable = true;

    git = {
	enable = true;
	userName = "Er Myril";
        userEmail = "ermyril@gmail.com";
       #signing = {
       #  key = "0FBCD3EE63107407";
       #  signByDefault = true;
       #};
	lfs.enable = true;
        extraConfig = {
          pull.ff = "only";
          pull.rebase = "true";
          init.defaultBranch = "master";
          credential.helper = "${pkgs.pass-git-helper}/bin/pass-git-helper";
	};
    };

    htop.enable = true;

    keychain = 
    {
	enable = true;
    };
  };

  nixpkgs.overlays = [
    (self: super: {
      fcitx-engines = pkgs.fcitx5;
    })
  ];

  services =  { };
}
