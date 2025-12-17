{ config, pkgs, ... }:

{

  # Helpful when you also run ollama from a user shell
  environment.systemPackages = [ 
    pkgs.cudatoolkit
  ];

  #####  Ollama service  ######################################################
  services.ollama = {
    enable       = true;
    openFirewall = true;             # expose TCP 11434 on the LAN (optional)
    package = pkgs.ollama-cuda;
    # loadModels   = [ "llama3:8b" ];  # pre-pull models at boot (optional)
  };
}
