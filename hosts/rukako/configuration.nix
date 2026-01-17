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

  services.caddy = {
    enable = true;
    package = config.nixpkgs.overlays.caddy; # Use default caddy package

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

  nixpkgs.overlays = [
    (self: super: {
      caddy = super.caddy.override {
        plugins = with super.caddy-plugins; [
          exec
        ];
      };
    })
  ];
}