{
  fileSystems."/mnt/NAS" = {
    device = "192.168.88.42:/export/HDD";
    fsType = "nfs";
  };
  # optional, but ensures rpc-statsd is running for on demand mounting
  boot.supportedFilesystems = [ "nfs" ];
}


