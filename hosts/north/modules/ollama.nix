{ config, pkgs, ... }:

{

  # Helpful when you also run ollama from a user shell
  environment.systemPackages = [ pkgs.cudatoolkit ];

  #####  Ollama service  ######################################################
  services.ollama = {
    enable       = true;
    acceleration = "cuda";           # GPU build – see wiki example :contentReference[oaicite:0]{index=0}
    openFirewall = true;             # expose TCP 11434 on the LAN (optional)
    # loadModels   = [ "llama3:8b" ];  # pre-pull models at boot (optional)
  };
}
