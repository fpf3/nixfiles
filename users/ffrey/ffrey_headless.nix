{ config, lib, pkgs, ... }:
{
    imports = 
    [
      <home-manager/nixos>
    ];
    
    users.users.ffrey = (import ./user.nix) { pkgs=pkgs; };
    
    programs.zsh.enable = true; # Enable ZSH system-wide

    # Home Manager
    home-manager.users.ffrey = (import ./home.nix) { 
      pkgs=pkgs; 
      lib=lib; 
     
     # installed packages
      userPackages = 
        (import ../../frags/pkgs/custom.nix { pkgs=pkgs; })
      ++(import ../../frags/pkgs/general_dev.nix { pkgs=pkgs; })
      ++(import ../../frags/pkgs/py_dev.nix { pkgs=pkgs; })
      ++(import ../../frags/pkgs/scripts.nix { pkgs=pkgs; })
      ++(import ../../frags/pkgs/utils.nix { pkgs=pkgs; });
    };
}
