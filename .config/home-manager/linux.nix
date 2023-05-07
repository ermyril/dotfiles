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
  ];
  apps = with pkgs; [
    ffmpeg-full
    tdesktop #telegram
    vlc
    extremetuxracer
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
    vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [ vim-airline vim-tmux-navigator ];
      settings = { ignorecase = true; };
      extraConfig = ''
        set mouse=a
      '';
    };
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
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      shellAliases =
      {
        ll = "ls -al";
        ".." = "cd ..";
        update = "sudo nixos-rebuild switch --flake .#sabbath";
        search = "nix search nixpkgs";
        clean = "nix-collect-garbage -d";
      };
      oh-my-zsh = {
        enable = true;
     #   custom = ".config/ohmyzsh/custom";
        plugins = [ "git" ];
        theme = "darkblood";
      };
      plugins = [
	{
            name = "zsh-syntax-highlighting";
            src = pkgs.fetchFromGitHub {
              owner = "zsh-users";
              repo = "zsh-syntax-highlighting";
              rev = "caa749d030d22168445c4cb97befd406d2828db0";
 	      sha256 = "sha256-YV9lpJ0X2vN9uIdroDWEize+cp9HoKegS3sZiSpNk50=";
            };
	}
	{
            name = "zsh-autosuggestions";
            src = pkgs.fetchFromGitHub {
              owner = "zsh-users";
              repo = "zsh-autosuggestions";
	      rev = "a411ef3e0992d4839f0732ebeb9823024afaaaa8";
	      sha256 = "1g3pij5qn2j7v7jjac2a63lxd97mcsgw6xq6k5p7835q9fjiid98";
            };
	}
      ];
    };

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
