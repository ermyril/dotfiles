{ lib, pkgs, config, ... }:

{
  options = {
    mySystem.primaryUser = lib.mkOption {
      type = lib.types.str;
      description = "Primary user name";
    };
    
    mySystem.primaryUserFullName = lib.mkOption {
      type = lib.types.str;
      description = "Primary user full name";
      default = config.mySystem.primaryUser;
    };
  };

  config = {
    # Enable fish shell
    programs.fish.enable = true;

    # Platform-specific user configuration
    users.users.${config.mySystem.primaryUser} = {
      shell = pkgs.fish;
    } // lib.optionalAttrs pkgs.stdenv.isLinux {
      isNormalUser = true;
      description = config.mySystem.primaryUserFullName;
      extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
    } // lib.optionalAttrs pkgs.stdenv.isDarwin {
      name = config.mySystem.primaryUser;
      home = "/Users/${config.mySystem.primaryUser}";
    };

  };
}