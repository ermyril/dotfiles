{ pkgs, lib, ... }:

{
  imports = [
    ../../modules/nixos/proxmox/basic.nix
  ];

  boot.isContainer = true;

  systemd.suppressedSystemUnits = [
    "dev-mqueue.mount"
    "sys-kernel-debug.mount"
    "sys-fs-fuse-connections.mount"
  ];

  fileSystems."/" = {
    device = "/dev/sda1"; # Ignored, but required by NixOS
    fsType = "ext4";
  };

  networking.hostName = "rukako";

  # Allow Mailcow and Caddy ports
  networking.firewall.allowedTCPPorts = [ 22 25 80 443 465 587 143 993 110 995 ];

  environment.systemPackages = with pkgs; [
    wakeonlan
  ];


  # https://github.com/dulli/caddy-wol/tree/v1.0.0
  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/dulli/caddy-wol@v1.0.0" ];
      hash = "sha256-aXyA6Oqtbvok2ejI0f7aciy1Ud+4YIrzQnF5KXkayw4=";
    };

    virtualHosts."chat.ermyril.com" = {
      # This will be the default host
      hostName = "chat.ermyril.com";
      extraConfig = ''
        reverse_proxy 192.168.88.50:11434 {
            lb_try_duration 60s
            lb_try_interval 3s
        }
      '';
    };
  };

  system.stateVersion = "25.11";
}
