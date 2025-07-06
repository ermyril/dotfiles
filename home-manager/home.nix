{pkgs, ...}: {
    home.username = "ermyril";
    home.homeDirectory = "/home/ermyril";
    home.stateVersion = "25.05"; 
    programs.home-manager.enable = true;
    home.packages = [
       pkgs.nixpkgs-fmt
    ];
}
