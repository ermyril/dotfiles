{ config, lib, pkgs, ... }:

{
    programs.ssh = {
       enable = true;
       matchBlocks = {
          "github.com" = {
            hostname = "ssh.github.com";
            port = 443;
            identityFile = "~/.ssh/id_rsa";
            user = "git";
          };
          "proxmox" = {
            hostname = "192.168.88.35";
            identityFile = "~/.ssh/ermyril";
            user = "root";
          };
          "gitlab.com" = {
            hostname = "gitlab.com";
            identityFile = "~/.ssh/ermyril";
            user = "git";
          };
          "eosprod" = {
            hostname = "193.19.100.91";
            identityFile = "~/.ssh/redcollar";
            port = 2223;
            user = "admin-vm";
          };
          "eos" = {
            hostname = "193.19.100.91";
            identityFile = "~/.ssh/redcollar";
            port = 2224;
            user = "admin-vm";
          };
          "eoslk" = {
            hostname = "188.94.211.92";
            identityFile = "~/.ssh/redcollar";
            port = 2227;
            user = "root";
          };
          "eoslktestnew" = {
            hostname = "188.94.211.92";
            identityFile = "~/.ssh/redcollar";
            #port = 2228;
            port = 2224;
            user = "root";
          };
          "eoslksentry" = {
            hostname = "188.94.211.92";
            identityFile = "~/.ssh/redcollar";
            port = 2229;
            user = "root";
          };
          "doserver" = {
            hostname = "142.93.229.84";
            identityFile = "~/.ssh/ermyril";
            user = "root";
          };
          "proxy" = {
            hostname = "84.201.142.71";
            identityFile = "~/.ssh/redcollar";
            user = "ubuntu";
          };
        };
    };
}
