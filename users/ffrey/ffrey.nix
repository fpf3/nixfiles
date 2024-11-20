{ config, lib, pkgs, ... }:
let
  username = "ffrey";
in
{
    imports = 
    [
      <home-manager/nixos>
    ];
    
    users.users.ffrey = (import ./user.nix) { pkgs=pkgs; };
    
    programs.zsh.enable = true; # Enable ZSH system-wide

    services.pcscd.enable = true; # system-wide pcscd enable

    # give me the man pages... christ
    documentation.dev.enable = true;

    # Home Manager
    home-manager.users.ffrey = (import ../../frags/home/home.nix) { 
      pkgs=pkgs; 
      lib=lib;
      
      fullName = "Fred Frey";
      emailAddr = "f.frey@qvii.com";

      envVars = {
        QT_QPA_PLATFORM_PLUGIN_PATH = with pkgs; "${qt5.qtbase.bin}/lib/qt-${qt5.qtbase.version}/plugins/platforms";
      };

      # configs
      gtk = {
        enable = true;
      };
      
      qt = {
        enable = true;
      };

      # installed packages

      userPackages = 
        (import ../../frags/pkgs/general_dev.nix { pkgs=pkgs; })
      ++(import ../../frags/py_dev.nix { pkgs=pkgs; })
      ++(import ../../frags/scripts.nix { pkgs=pkgs; })
      ++(import ../../frags/utils.nix { pkgs=pkgs; });
    };
    

    # installed packages
}
