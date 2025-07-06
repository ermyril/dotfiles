{

  networking.firewall.checkReversePath = false; 

  networking.firewall = {
    allowedUDPPorts = [ 51820 ]; 
  };

  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ "10.13.13.3/24" ];
      #dns = [ "10.13.13.1" ];
      #privateKeyFile = "/root/.wireguard-keys/peer_ermyril/privatekey-peer_ermyril";
      privateKey = "QI3aDNxm5dYb/7A6rBOfKjFttsR7JV0eyqUfeT2cTX0=";
      
      peers = [
        {
          publicKey = "0leVwg8PLqNXkn5Tc35P4lC+JKauKAcj7BQiDi4P6Gw=";
          presharedKey = "mrRN6WFHsz5G0w6x9Hszn4+GDtpMPwd7AGLWQ3cGb4k=";
          #presharedKeyFile = "mrRN6WFHsz5G0w6x9Hszn4+GDtpMPwd7AGLWQ3cGb4k=";
          #allowedIPs = [ "0.0.0.0/0" "::/0" ];
          allowedIPs = [ "10.13.13.0/24" "192.168.88.0/24" "188.94.211.92/24"];
          endpoint = "142.93.229.84:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}

