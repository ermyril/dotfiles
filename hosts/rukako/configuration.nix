{ pkgs, lib, ... }:

{
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
    caddy
  ];


  # https://github.com/dulli/caddy-wol/tree/v1.0.0
  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/dulli/caddy-wol@v1.0.0" ];
      hash = "sha256-aXyA6Oqtbvok2ejI0f7aciy1Ud+4YIrzQnF5KXkayw4=";
    };

    globalConfig = ''
      order wake_on_lan before respond
    '';

    virtualHosts."192.168.88.8" = {
      # This will be the default host
      hostName = "192.168.88.8";
      listenAddresses = [ "0.0.0.0" ];
      extraConfig = ''
          reverse_proxy http://192.168.88.50:11434
          handle_errors {
                  @502 expression {err.status_code} == 502
                  handle @502 {
                          wake_on_lan 24:4b:fe:57:b1:f0
                          reverse_proxy 192.168.88.50:11434 {
                                  lb_try_duration 120s
                          }
                  }
          }
      '';
    };
  };

  system.stateVersion = "25.11";
}
