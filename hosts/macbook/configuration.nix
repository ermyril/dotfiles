{ config, pkgs, lib, inputs, self, ... }:

{
  imports = [
    ./yabai.nix
    ./skhd.nix
  ];
  # Disable nix daemon on macOS (managed by nix-darwin)
  nix.enable = false;

  # Make NUR available
  nixpkgs.overlays = [ inputs.nur.overlays.default ];

  # Set primary user for nix-darwin and configure options
  mySystem.primaryUser = "mikhaini";
  system.primaryUser = "mikhaini";
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # macOS version compatibility
  system.stateVersion = 6;

  system.defaults = {
    # Finder settings
    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      ShowPathbar = true;
      ShowStatusBar = true;
      FXEnableExtensionChangeWarning = false;
      FXPreferredViewStyle = "clmv"; # Column view
    };

    # Additional system settings can be added here
  };

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
      home = {
        username = "mikhaini";
        homeDirectory = "/Users/mikhaini";
        stateVersion = "25.05";
      };
    };
  };

}
