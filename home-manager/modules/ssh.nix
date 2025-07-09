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
          "gitlab.com" = {
            hostname = "gitlab.com";
            identityFile = "~/.ssh/ermyril";
            user = "git";
          };
          "kurisu" = {
            hostname = "192.168.88.35";
            identityFile = "~/.ssh/ermyril";
            user = "root";
          };
          "kyouma" = { 
            hostname = "93.95.228.13";
            identityFile = "~/.ssh/ermyril";
            user = "root";
          };
          "daru" = {
            hostname = "142.93.229.84";
            identityFile = "~/.ssh/ermyril";
            user = "root";
          };
          "proxmox" = {
            hostname = "192.168.88.35";
            identityFile = "~/.ssh/ermyril";
            user = "root";
          };
          "doserver" = {
            hostname = "142.93.229.84";
            identityFile = "~/.ssh/ermyril";
            user = "root";
          };
          "eoslk" = {
            hostname = "188.94.211.70";
            identityFile = "~/.ssh/ermyril";
            port = 2224;
            user = "admin-vm";
          };
          "eoslktest" = {
            hostname = "188.94.211.70";
            identityFile = "~/.ssh/ermyril";
            port = 2228;
            user = "admin-vm";
          };
          "eossentry" = {
            hostname = "188.94.211.70";
            identityFile = "~/.ssh/redcollar";
            port = 2229;
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
