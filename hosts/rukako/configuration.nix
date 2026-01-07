{ ... }:

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

  # Allow Mailcow ports
  networking.firewall.allowedTCPPorts = [ 22 25 80 443 465 587 143 993 110 995 ];

  system.stateVersion = "25.11";
}