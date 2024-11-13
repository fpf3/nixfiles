{ config, lib, pkgs, ... }:
let
  #fpf3_dwm = pkgs.callPackage (builtins.fetchurl "https://git.fpf3.net/dwm/plain/default.nix") {};
  fpf3_dwm = pkgs.callPackage ../../custom_pkgs/dwm/default.nix {};
  fpf3_st = pkgs.callPackage ../../custom_pkgs/st/default.nix {};
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
    home-manager.users.ffrey = (import ./home.nix) { 
      pkgs=pkgs; 
      lib=lib;

      # configs
      gtk = {
        enable = true;
      };
      
      qt = {
        enable = true;
      };

      # installed packages

      userPackages = ((import ./headless_pkgs.nix) { pkgs=pkgs; })
      ++ (with pkgs; [ # Upstream packages
          feh
          imagemagick
          scrot
          xclip
          yubioath-flutter
      ])
      ++ [ # Custom packages
        fpf3_dwm
        fpf3_st
      ]
      ++ (with (pkgs.callPackage ../../scripts/scripts.nix {}); [ # scripts
          snip
          statusbar
          xsandbox
      ]);
    };
    

    # installed packages
}
