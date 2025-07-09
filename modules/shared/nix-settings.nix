{ lib, pkgs, ... }:

{
  # Common nix settings for both NixOS and nix-darwin
  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      auto-optimise-store = true;
    };
    
    # Garbage collection settings (Linux only - Determinate Systems handles this on macOS)
    gc = lib.mkIf pkgs.stdenv.isLinux {
      automatic = lib.mkDefault true;
      options = lib.mkDefault "--delete-older-than 7d";
      dates = lib.mkDefault "weekly";
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}