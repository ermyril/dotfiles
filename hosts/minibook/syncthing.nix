{ config, lib, pkgs, ... }:

{
  services = {
    syncthing = {
      enable = true;
      user = "ermyril";
      dataDir = "/home/ermyril/Documents";
      configDir = "/home/ermyril/.config/syncthing";

      overrideDevices = true;     # overrides any devices added or deleted through the WebUI
      overrideFolders = true;     # overrides any folders added or deleted through the WebUI
      settings = {
        devices = {
         "note20" = { id = "CPXMCMS-WYTTWIR-FVB3FHT-4EYBCF2-R2XCCQQ-NXSL6P7-XQ3WA5O-F2YVZA2"; };
         "DO Server" = { id = "4OMN5LW-PX6V2YF-HZQJRBL-QGSUSLW-55DMJEB-3J3JRGS-6CFGI4F-E6LWIAF"; };
        };
        folders = {
          "Documents" = {        # Name of folder in Syncthing, also the folder ID
            path = "/home/ermyril/Documents";    # Which folder to add to Syncthing
            devices = [ ];      # Which devices to share the folder with
          };
          "Notes" = {
            path = "/home/ermyril/Notes";
            devices = [ "DO Server" ];
            ignorePerms = false; # By default, Syncthing doesn't sync file permissions. This line enables it for this folder.
          };
        };
      };
    };
  };
}
