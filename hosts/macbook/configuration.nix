{ config, pkgs, lib, inputs, ... }:

{
  # Enable nix flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ]; # probably will not work with nix.enable, set in /etc/nix
  nix.enable = false;
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Make NUR available
  nixpkgs.overlays = [ inputs.nur.overlays.default ];

  # macOS system packages (things that need system-level installation)
  environment.systemPackages = with pkgs; [
    yabai
    skhd
  ];


  # Set primary user for nix-darwin
  system.primaryUser = "mikhaini";
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

 #system = {
 #  # macOS version compatibility
 #  stateVersion = 6;
 #  
 #  defaults = {
 #    # Dock settings
 #    dock = {
 #      autohide = true;
 #      autohide-delay = 0.0;
 #      autohide-time-modifier = 0.2;
 #      orientation = "bottom";
 #      show-recents = false;
 #      static-only = true;
 #      tilesize = 48;
 #    };

 #    # Finder settings
 #    finder = {
 #      AppleShowAllExtensions = true;
 #      AppleShowAllFiles = true;
 #      ShowPathbar = true;
 #      ShowStatusBar = true;
 #      FXEnableExtensionChangeWarning = false;
 #      FXPreferredViewStyle = "clmv"; # Column view
 #    };

 #    # System UI settings
 #    NSGlobalDomain = {
 #      AppleShowAllExtensions = true;
 #      AppleShowScrollBars = "Always";
 #      NSDocumentSaveNewDocumentsToCloud = false;
 #      NSTableViewDefaultSizeMode = 2;
 #      "com.apple.swipescrolldirection" = false; # Natural scrolling off
 #    };

 #    # Additional system settings can be added here
 #  };

 #  # Keyboard settings
 #  keyboard = {
 #    enableKeyMapping = true;
 #    remapCapsLockToEscape = true;
 #  };
 #};

  # Homebrew integration (for GUI apps not available in nixpkgs)
 #homebrew = {
 #  enable = true;
 #  onActivation = {
 #    cleanup = "zap";
 #    autoUpdate = true;
 #    upgrade = true;
 #  };
 #  
 #  # GUI applications from Homebrew
 #  casks = [
 #    "raycast"
 #    "arc"
 #    "notion"
 #    "spotify"
 #    "discord"
 #    "zoom"
 #    "rectangle"
 #  ];
 #  
 #  # Mac App Store apps
 #  masApps = {
 #    "Xcode" = 497799835;
 #    "TestFlight" = 899247664;
 #  };
 #};

  # User configuration
  users.users.mikhaini = {
    name = "mikhaini";
    home = "/Users/mikhaini";
  };

  # Home Manager integration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    
    users.mikhaini = {
     #imports = [ ../../home-manager/default.nix ];
      
      # User-specific settings
      home = {
        username = "mikhaini";
        homeDirectory = "/Users/mikhaini";
        stateVersion = "25.05";
      };
    };
  };
}
