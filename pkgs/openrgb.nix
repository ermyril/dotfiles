{ pkgs, ... }:

pkgs.openrgb-with-all-plugins.overrideAttrs (oldAttrs: rec {
  version = "0.9-rc1+git-0fca93e";

  src = pkgs.fetchFromGitLab {
    owner = "CalcProgrammer1";
    repo = "OpenRGB";
    rev = "0fca93e4544f943d4d7ec8073dba4e47c18ef54b";
    sha256 = pkgs.lib.fakeHash;
  };
})