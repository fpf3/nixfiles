{ config, lib, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
in
{
    imports = 
    [
      (import "${home-manager}/nixos")
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
