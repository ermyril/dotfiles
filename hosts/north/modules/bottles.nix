{ pkgs, ... }:

let
  # 32-bit and 64-bit plugin stacks
  gst32 = pkgs.pkgsi686Linux.gst_all_1;
  gst64 = pkgs.gst_all_1;

  toDir = p: "${p}/lib/gstreamer-1.0";
  gstDirs = map toDir [
    gst32.gstreamer      gst32.gst-plugins-base  gst32.gst-plugins-good
    gst32.gst-plugins-bad gst32.gst-plugins-ugly gst32.gst-libav
    gst64.gstreamer      gst64.gst-plugins-base  gst64.gst-plugins-good
    gst64.gst-plugins-bad gst64.gst-plugins-ugly gst64.gst-libav
  ];
  gstPath = builtins.concatStringsSep ":" gstDirs;

  wrappedBottles =
    pkgs.writeShellScriptBin "bottles" ''
      #!${pkgs.bash}/bin/bash
      export LD_LIBRARY_PATH="${gst32.gstreamer}/lib:${"$"}LD_LIBRARY_PATH"
      export GST_PLUGIN_SYSTEM_PATH_1_0='${gstPath}'
      export GST_PLUGIN_FEATURE_RANK='nvh264dec:0,nvh265dec:0,nvdec:0,nvcodec:0'
      exec ${pkgs.steam-run}/bin/steam-run ${pkgs.bottles}/bin/bottles "$@"
    '';
in
{
  environment.systemPackages = with pkgs; [
    wrappedBottles          # <-- the wrapped executable
    #bottles                 # (optional) keep the original for comparison
  ];
}

