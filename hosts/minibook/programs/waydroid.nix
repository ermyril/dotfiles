{ config, lib, pkgs, ... }:

{

  virtualisation.waydroid.enable = true;

  environment.systemPackages = with pkgs; [
    mutter
  ];

  services.xserver.displayManager.session = [ 
    { 
      manage = "desktop";
      name = "Android";
      start = ''
        #!/bin/sh
        mutter --wayland &
        waydroid show-full-ui
      '';
    }
  ];
}
