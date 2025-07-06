# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs,  ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

fileSystems = {
  "/".options = [ "compress=zstd" ];
  "/home".options = [ "compress=zstd" ];
  "/nix".options = [ "compress=zstd" "noatime" ];
  #"/swap".options = [ "noatime" ];
};

########nix.gc = {
########  automatic = true;
########  dates     = "weekly";
########  options   = "--delete-older-than 30d";
########};



 nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    #substituters = ["https://hyprland.cachix.org"];
    #trusted-substituters = ["https://hyprland.cachix.org"];
    #trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

hardware.enableRedistributableFirmware = true;

services.flatpak.enable = true;
programs.appimage.enable = true;
programs.appimage.binfmt = true;
nixpkgs.config.allowUnfree = true;
# Use the systemd-boot EFI boot loader.
boot.loader.efi.canTouchEfiVariables = true;

boot = {


    loader.systemd-boot = {
	    enable = true;
	    consoleMode = "max";     # or GRUB gfxmode*, not both
 	    configurationLimit = 20;
    };


    plymouth = {
      enable = true;
      theme  = "bgrt";
      #themePackages = [ pkgs.adi1090x-plymouth-themes ];
    };

    kernelParams = [ "quiet" "splash"];
  };


#boot.extraModprobeConfig = ''
#  options nvidia NVreg_PreserveVideoMemoryAllocations=1 \
#                 NVreg_TemporaryFilePath=/var/tmp
#'';

programs.virt-manager.enable = true;

users.groups.libvirtd.members = ["ermyril" "penguin"];

virtualisation.libvirtd.enable = true;

virtualisation.spiceUSBRedirection.enable = true;

  networking.hostName = "north"; 
  # Pick only one of the below networking options.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Prague";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.

  i18n.defaultLocale = "en_US.UTF-8";
 #console = {
 #  font = "ter-v32b";
 #  useXkbConfig = true; # use xkb.options in tty.
 #};

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = ["nvidia"];


  #services.displayManager.cosmic-greeter.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.cosmic.enable = true;
  services.desktopManager.gnome.enable = true;
  
programs.hyprland.enable = true;

hardware.nvidia = {
  modesetting.enable = true;
  powerManagement.enable = true;
  powerManagement.finegrained = false;

  open = false; 
  nvidiaSettings = true;
};


  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };
  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.penguin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; 
    packages = with pkgs; [];
  };

   security.sudo.wheelNeedsPassword = false;


  users.users.ermyril = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; 
    packages = with pkgs; [ telegram-desktop ];
  };

   programs.firefox.enable = true;


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim 
    wget
    git
    curl
    kitty
    openrgb-with-all-plugins
    flycast
    kdePackages.kdenlive
    mesa-demos
    deluge


	gst_all_1.gstreamer
	gst_all_1.gst-plugins-base 
	gst_all_1.gst-plugins-good 
	gst_all_1.gst-plugins-bad 
	gst_all_1.gst-plugins-ugly 
	gst_all_1.gst-libav 

    pkgsi686Linux.gst_all_1.gstreamer
    pkgsi686Linux.gst_all_1.gst-plugins-base
    pkgsi686Linux.gst_all_1.gst-plugins-good
    pkgsi686Linux.gst_all_1.gst-plugins-bad
    pkgsi686Linux.gst_all_1.gst-plugins-ugly
    pkgsi686Linux.gst_all_1.gst-libav

bottles

	gnutls 
	libidn

	steam-run
        mangohud
vscode

    


	vulkan-tools
	clinfo
        mangohud protonup-qt 
  	davinci-resolve

	gnomeExtensions.pop-shell
	gnomeExtensions.dash-to-dock
	nautilus

	hyprpanel
	hyprnome
	hyprshell
	hyprshot

    hyprlandPlugins.hyprbars
    hyprlandPlugins.hyprexpo


   #(pkgs.wrapOBS {
   #   plugins = with pkgs.obs-studio-plugins; [
   #     wlrobs
   #     obs-backgroundremoval
   #     obs-pipewire-audio-capture
   #     droidcam-obs
   #     advanced-scene-switcher
   #   ];
  #})
  ];


programs.obs-studio = {
    enable = true;

    # optional Nvidia hardware acceleration
    package = (
      pkgs.obs-studio.override {
        cudaSupport = true;
      }
    );

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-gstreamer
      obs-vkcapture
      droidcam-obs
      advanced-scene-switcher
    ];
  };

xdg.portal = {
  enable = true;

  # Pick ONE backend that matches your session.
  # COSMIC backend only exists on very fresh nixpkgs; otherwise fall back to gtk.
  extraPortals = with pkgs; [
    xdg-desktop-portal-cosmic     # <- if available
    # xdg-desktop-portal-gtk      # <- safe fallback
  ];

  # Optional but handy: make “xdg-open” always use the portal
  xdgOpenUsePortal = true;
};


hardware.graphics = {
   enable = true;
   enable32Bit = true;
   extraPackages = with pkgs; [
     mesa
     libva
     libvdpau-va-gl
     vulkan-loader
     vulkan-validation-layers
     #amdvlk  # Optional: AMD's proprietary Vulkan driver
     mesa.opencl  # Enables Rusticl (OpenCL) support
   ];
 };

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  users.extraGroups.vboxusers.members = [ "ermyril" "penguin" ];

  services.hardware.openrgb.enable = true;


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

	 #programs.steam = {
	 #  enable = true;
	 #  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
	 #  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
	 #  localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
	 #};

	 #nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
	 #  "steam"
	 #  "steam-original"
	 #  "steam-unwrapped"
	 #  "steam-run"
	 #];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}

