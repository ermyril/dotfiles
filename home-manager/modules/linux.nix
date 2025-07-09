{
  nixpkgs,
  lib, 
  config, 
  pkgs, 
  ... 
}:
{
  # Linux-specific imports only
  imports = [
    ./emacs.nix
    #./syncthing.nix
    #./wireguard.nix
  ];

  # NUR is handled by the flake overlays

  # Linux-specific packages only
  home.packages = with pkgs; [
    # Development tools (Linux-specific)
    vscode
    ctags
    libtool
    insomnia
    at

    # GNOME/Linux desktop
    gnome.gnome-tweaks
    gnome.dconf-editor
    gnomeExtensions.pop-shell
    gnomeExtensions.dash-to-dock
    gnomeExtensions.hide-top-bar
    gnomeExtensions.gjs-osk
    gnomeExtensions.screen-rotate
    dconf2nix # to generate nixconfig from dconf

    # System tools (Linux-specific)
    atop
    gparted
    wireshark

    # Applications (Linux-specific)
    logseq
    foliate
    gimp
    vlc
    #tdesktop #telegram

    # Media/Audio (Linux-specific)
    lmms
    ardour
    #reaper
    mixxx
    #vcv-rack
    deluge
    obs-studio
    # kicad
  ];

  # Linux-specific session variables
  home.sessionVariables = {
    # Fix for alacritty window decorations on gnome
    WAYLAND_DISPLAY = " ";
    EDITOR = "vim";
  };

  # Linux-specific programs configuration
  programs = {
    gpg = {
      enable = true;
      mutableKeys = true;
      settings = {
        # pinentry-program = "gnome";
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

    git = {
      enable = true;
      userName = "Er Myril";
      userEmail = "ermyril@gmail.com";
      # signing = {
      #   key = "0FBCD3EE63107407";
      #   signByDefault = true;
      # };
      lfs.enable = true;
      extraConfig = {
        pull.ff = "only";
        pull.rebase = "true";
        init.defaultBranch = "master";
        credential.helper = "${pkgs.pass-git-helper}/bin/pass-git-helper";
      };
    };


    keychain = {
      enable = true;
    };
  };

  # Linux-specific overlays
  nixpkgs.overlays = [
    (self: super: {
      fcitx-engines = pkgs.fcitx5;
    })
  ];

  services = { };
}
