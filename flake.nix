{
  description = "Home-manager configuration";

  inputs = {
     nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
     flake-utils.url = "github:numtide/flake-utils";
     home-manager = {
         url = "github:nix-community/home-manager";
         inputs.nixpkgs.follows = "nixpkgs";
     };
     nur = {
       url = "github:nix-community/NUR";
       inputs.nixpkgs.follows = "nixpkgs";
     };
   };

  outputs = { self, nixpkgs, nur, home-manager, flake-utils, ... }: {

    defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;


        homeConfigurations = {
            "ermyril" = home-manager.lib.homeManagerConfiguration {
                # Note: I am sure this could be done better with flake-utils or something
                pkgs = import nixpkgs { system = "x86_64-linux"; };

                modules = [ 
                  ({
                    nixpkgs.overlays = [
                      nur.overlays.default
                    ];
                  })
                  # inputs.nur.modules.homeManager.default
                  ./home.nix
                  ./.config/home-manager/tmux.nix 
                  ./.config/home-manager/vim.nix 
                  ./.config/home-manager/dconf.nix 
                  #./.config/home-manager/emacs.nix 
                  #./.config/home-manager/kmonad.nix # only linux
                  ./.config/home-manager/dotfiles.nix 
                  ./.config/home-manager/ssh.nix 
                  ./.config/home-manager/fish.nix 
                  ./.config/home-manager/firefox.nix 
                ]; 
            };
        };
  };
}
