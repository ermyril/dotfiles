{ ... }:

let
  isLinux = builtins.currentSystem == "x86_64-linux";
  isMacOS = builtins.currentSystem == "x86_64-darwin";
in
if isLinux then
{
  imports = [
      ./linux.nix
  ];
}
else if isMacOS then
{ 
  imports = [
      ./macos.nix
  ];
}
else
{
  # someday I'll try SomeBSD 
}

