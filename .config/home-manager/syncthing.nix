{ config, lib, pkgs, ... }:

{
  services = {
    syncthing = {
      enable = true;
      #dataDir = "/home/ermyril/Documents";
      #configDir = "/home/ermyril/.config/syncthing";
      overrideDevices = true;     # overrides any devices added or deleted through the WebUI
      overrideFolders = true;     # overrides any folders added or deleted through the WebUI
      devices = {
       "note20" = { id = "CPXMCMS-WYTTWIR-FVB3FHT-4EYBCF2-R2XCCQQ-NXSL6P7-XQ3WA5O-F2YVZA2"; };
       #"device2" = { id = "DEVICE-ID-GOES-HERE"; };
      };
      folders = {
        "Documents" = {        # Name of folder in Syncthing, also the folder ID
          path = "/home/myusername/Documents";    # Which folder to add to Syncthing
          devices = [ "device1" "device2" ];      # Which devices to share the folder with
        };
        "Notes" = {
          path = "/home/ermyril/Notes";
          devices = [ "phone" ];
          ignorePerms = false;     # By default, Syncthing doesn't sync file permissions. This line enables it for this folder.
        };
      };
    };
  };
}
