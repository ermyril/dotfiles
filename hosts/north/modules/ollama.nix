{ config, pkgs, ... }:

{

  # Helpful when you also run ollama from a user shell
  environment.systemPackages = [ 
    #pkgs.cudatoolkit
    #pkgs.aider-chat
    #pkgs.gemini-cli
  ];

  #####  Ollama service  ######################################################
  services.ollama = {
    enable       = false;
    openFirewall = false;             # expose TCP 11434 on the LAN (optional)
    #package = pkgs.ollama-cuda;
    # loadModels   = [ "llama3:8b" ];  # pre-pull models at boot (optional)
  };
}
