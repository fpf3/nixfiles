{ config, lib, pkgs, ... }:
{
    imports = 
    [
      <home-manager/nixos>
    ];
    
    users.users.fred = (import ./user.nix) { pkgs=pkgs; };
    
    programs.zsh.enable = true; # Enable ZSH system-wide

    # Home Manager
    home-manager.users.fred = (import ./home.nix) { 
      pkgs=pkgs; 
      lib=lib; 
     
     # installed packages
      userPackages = (import ./headless_pkgs.nix) { pkgs=pkgs; };
    };
}
