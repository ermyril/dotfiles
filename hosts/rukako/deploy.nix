{
  # Import the shared system configuration
  imports = [ ./configuration.nix ];

  # NixOps-specific deployment configuration
  deployment = {
    targetHost = "192.168.88.58"; # IP of your container
    targetUser = "root";
    
    # Since we are deploying to an LXC container, we don't manage the 
    # hardware/bootloader, just the system.
    # 'none' backend simply SSHs in and runs switch.
    targetEnv = "none"; 
  };
}
