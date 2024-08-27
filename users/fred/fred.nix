{ config, lib, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
  #fpf3_dwm = pkgs.callPackage (builtins.fetchurl "https://git.fpf3.net/dwm/plain/default.nix") {};
  fpf3_dwm = pkgs.callPackage (builtins.fetchurl "https://raw.githubusercontent.com/fpf3/dwm/master/default.nix") {};
  username = "fred";
in
{
    imports = 
    [
      (import "${home-manager}/nixos")
    ];
    
    users.users.fred = (import ./user.nix) { pkgs=pkgs; };
    
    programs.zsh.enable = true; # Enable ZSH system-wide

    services.pcscd.enable = true; # system-wide pcscd enable
    services.xserver.windowManager.dwm.package = fpf3_dwm;

    services.syncthing = {
      enable = true;
      user = "${username}";
      configDir = "/home/${username}/.config/syncthing";
    };

    # not packages per se, but this is what gives us virtualbox
    virtualisation.virtualbox.host.enable = true;
    users.extraGroups.vbox.members = [ "${username}" ];

    # give me the man pages... christ
    documentation.dev.enable = true;

    # steam system config
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };
    
    qt = {
      enable = true;
      platformTheme = "gnome";
      style = "adwaita-dark";
    };

    # Home Manager
    home-manager.users.fred = (import ./home.nix) { 
      pkgs=pkgs; 
      lib=lib;

      # configs
      dconf = {
        settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
          };
        };
      };

      gtk = {
        enable = true;
        theme = {
          name = "Adwaita-dark";
          package = pkgs.gnome.gnome-themes-extra;
        };
      };
      
      pointerCursor = {
        gtk.enable = true;
        x11.enable = true;
        name = "Adwaita";
        size=16;
        package = pkgs.gnome.adwaita-icon-theme;
      };

      # installed packages

      userPackages = ((import ./headless_pkgs.nix) { pkgs=pkgs; })
      ++ (with pkgs; [
          dmenu
          element-desktop
          feh
          firefox
          gnome.gnome-tweaks
          imagemagick
          lukesmithxyz-st
          mumble
          networkmanagerapplet
          pavucontrol
          picom
          prismlauncher
          pywal
          remmina
          rofi
          rofimoji
          scrot
          synergy
          thunderbird
          vesktop
          vlc
          xclip
          yubioath-flutter
      ])
      ++ [
        fpf3_dwm
      ]
      ++ (with (pkgs.callPackage ../../scripts/scripts.nix {}); [
          # Some helper scripts for DWM.
          as
          as_blocking
          snip
          statusbar
          xsandbox
      ]);
    };
    

    # installed packages
}
