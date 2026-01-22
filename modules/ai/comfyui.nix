{ config, lib, pkgs, comfyui-nix, ... }:
{
  imports = [ comfyui-nix.nixosModules.default ];
  nixpkgs.overlays = [ comfyui-nix.overlays.default ];

  services.comfyui = {
    enable = true;
    cuda = true;  
    #   Note: Pre-built PyTorch wheels already support all GPU architectures
    enableManager = true;  # 
    port = 8188;
    listenAddress = "0.0.0.0";  
    dataDir = "/var/lib/comfyui";
    openFirewall = false;
    # extraArgs = [ "--lowvram" ];
    # environment = { };
  };
}
