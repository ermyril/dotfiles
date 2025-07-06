{
  description = "Unified NixOS + Home-Manager flake for north, minibook, and mac.";

  inputs = {
    # Core channels
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home-Manager (stand-alone + nixos module later)
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # NUR overlay (already used in current configs)
    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";

    # Utility helpers
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, home-manager, nur, flake-utils, ... }:
    let
      inherit (nixpkgs.lib) nixosSystem;

      # Helper: create a stand-alone home-manager config for a given system
      mkHome = system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };

          modules = [
            # Make NUR available to HM
            ({ nixpkgs.overlays = [ nur.overlays.default ]; })

            # Existing HM entrypoint (we will modularise later)
            ./home-manager/home.nix
          ];
        };
    in {
      ############################################################
      ## NixOS Hosts  (HM-as-module will be wired later)
      ############################################################
      nixosConfigurations = {
        north = nixosSystem {
          system  = "x86_64-linux";
          modules = [
            ./hosts/north/configuration.nix
          ];
        };

        minibook = nixosSystem {
          system  = "x86_64-linux";
          modules = [
            ./hosts/minibook/configuration.nix
          ];
        };
      };

      ############################################################
      ## Stand-alone Home-Manager (macbook)
      ############################################################
      homeConfigurations."ermyril@mac" = mkHome "aarch64-darwin";

      # flake-utils defaultPackage/devShell, etc. can be added later if needed
    };
}
