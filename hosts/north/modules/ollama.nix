{ config, pkgs, ... }:

{

  environment.systemPackages = [ 
    #pkgs.cudatoolkit
    pkgs.aider-chat
    #pkgs.gemini-cli
  ];

  #####  Ollama service  ######################################################
  services.ollama = {
    enable       = true;
    host = "0.0.0.0";
    port = 11434;
    package = pkgs.ollama-cuda;
    loadModels   = [ "llama3:8b" ];  # pre-pull models at boot (optional)
  };

  #services.open-webui.enable = true; #triggers cuda build from source
  networking.firewall.allowedTCPPorts = [ 11434 8080 ]; 

}
