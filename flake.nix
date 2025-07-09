{
  description = "Unified NixOS + Home-Manager flake for north, minibook, and mac.";

  inputs = {
    # Core channels
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home-Manager (stand-alone + nixos module later)
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # nix-darwin for macOS system management
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # NUR overlay (already used in current configs)
    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";

    # KMonad (keyboard remapper) Nix module
    kmonad = {
      url = "git+https://github.com/kmonad/kmonad?submodules=1&dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Utility helpers
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin, nur, flake-utils, kmonad, ... }:
    let
      inherit (nixpkgs.lib) nixosSystem;


    in {
      # expose selected flake inputs for host configs that do
      #   (import ../../flake.nix).inputs.<name>
      inputs = {
        inherit kmonad nur home-manager nix-darwin nixpkgs flake-utils;
      };

      ############################################################
      ## NixOS Hosts
      ############################################################
      nixosConfigurations = {
        north = nixosSystem {
          system  = "x86_64-linux";
          modules = [
            ./hosts/north/configuration.nix
            ./modules/shared/nix-settings.nix
            ./modules/shared/users.nix
            ./modules/shared/packages/common.nix
            ./modules/nixos/packages.nix
            ({ nixpkgs.overlays = [ nur.overlays.default ]; })
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "bak";
              home-manager.users.ermyril = {
                imports = [ 
                  ./home-manager/default.nix
                  ./home-manager/platforms/linux.nix
                ];
                home.stateVersion = "25.05";
              };
            }
          ];
        };

        minibook = nixosSystem {
          system  = "x86_64-linux";
          modules = [
            ./hosts/minibook/configuration.nix
            ./modules/shared/nix-settings.nix
            ./modules/shared/users.nix
            ./modules/shared/packages/common.nix
            ./modules/nixos/packages.nix
            ({ nixpkgs.overlays = [ nur.overlays.default ]; })
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "bak";
              home-manager.users.ermyril = {
                imports = [ 
                  ./home-manager/default.nix
                  #./home-manager/platforms/linux.nix
                ];
                home.stateVersion = "22.11";
              };
            }
          ];
        };
      };

      ############################################################
      ## macOS Hosts (nix-darwin)
      ############################################################
      darwinConfigurations.macbook = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { 
          inputs = { inherit kmonad nur home-manager nix-darwin nixpkgs flake-utils; };
          inherit self;
        };
        modules = [
          ./hosts/macbook/configuration.nix
          ./modules/shared/nix-settings.nix
          ./modules/shared/users.nix
          ./modules/shared/packages/common.nix
          ./modules/darwin/packages.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "bak";
            home-manager.users.mikhaini = {
              imports = [ 
                ./home-manager/default.nix
                ./home-manager/platforms/darwin.nix
              ];
              home.stateVersion = "25.05";
            };
          }
        ];
      };

      # flake-utils defaultPackage/devShell, etc. can be added later if needed
    };
}
