{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.mailcow;
in
{
  options.services.mailcow = {
    enable = mkEnableOption "Mailcow mail server";
    
    dataDir = mkOption {
      type = types.str;
      default = "/opt/mailcow-dockerized";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;
    
    environment.systemPackages = [
      (pkgs.writeShellScriptBin "mailcow-setup" ''
        set -e
        MAILCOW_DIR="${cfg.dataDir}"
        
        if [ ! -d "$MAILCOW_DIR" ]; then
          mkdir -p "$MAILCOW_DIR"
          cd "$MAILCOW_DIR"
          git clone https://github.com/mailcow/mailcow-dockerized.git .
          bash generate_config.sh
          echo "Done! Run: cd $MAILCOW_DIR && docker-compose up -d"
        else
          echo "Mailcow directory already exists."
        fi
      '')
    ];
  };
}

