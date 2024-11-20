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
      userPackages = (import ./headless_pkgs.nix) { pkgs=pkgs; };
    };
}
