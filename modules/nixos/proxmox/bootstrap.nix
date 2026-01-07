{ modulesPath, ... }:

{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
  ];

  boot.isContainer = true;

  systemd.suppressedSystemUnits = [
    "dev-mqueue.mount"
    "sys-kernel-debug.mount"
    "sys-fs-fuse-connections.mount"
  ];

  # Enable DHCP for the base image
  networking.useDHCP = true;

  # Enable SSH for initial access
  services.openssh.enable = true;

  system.stateVersion = "24.05";
}
