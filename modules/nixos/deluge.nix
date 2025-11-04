{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.mySystem.deluge;
in
{
  options.mySystem.deluge = {
    enable = mkEnableOption "Deluge BitTorrent client with declarative configuration";

    shareRatioLimit = mkOption {
      type = types.str;
      default = "0";
      description = "Share ratio limit (0 = unlimited seeding)";
    };

    seedTime = mkOption {
      type = types.str;
      default = "0";
      description = "Seed time limit (0 = infinite seeding time)";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = true;
      description = "Open firewall ports for Deluge";
    };

  };

  config = mkIf cfg.enable {
    # Enable Deluge service
    services.deluge = {
      enable = true;
      declarative = true;
      openFirewall = cfg.openFirewall;
      authFile = pkgs.writeText "deluge-auth" "localclient::10\n";
      config = {
        share_ratio_limit = cfg.shareRatioLimit;
        seed_time = cfg.seedTime;
      };
    };

    # Include deluge package
    environment.systemPackages = with pkgs; [
      deluge
    ];
  };
}
