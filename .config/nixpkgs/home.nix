{ ... }:

let
  isLinux = builtins.currentSystem == "x86_64-linux";
  isMacOS = builtins.currentSystem == "x86_64-darwin";
in
{
    imports = [
        ./macos.nix
    ];
}

# if isLinux then
#   { inherit (import ./linux.nix) fileToInclude; }
# else if isMacOS then
#   { inherit (import ./macos.nix) fileToInclude; }
# else
#   {
#     # someday I'll try SomeBSD 
#   }
