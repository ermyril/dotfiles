{
  fileSystems = {
    "/".options = [ "compress=zstd" "discard" ];
    "/home".options = [ "compress=zstd" "noatime" "discard"];
    "/nix".options = [ "compress=zstd" "noatime" "discard"];
    "/boot".options = [ "umask=0077" ];
  };
}
