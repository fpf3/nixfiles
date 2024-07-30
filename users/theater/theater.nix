{ config, lib, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
in
{
    imports = 
    [
      (import "${home-manager}/nixos")
    ];
    
    users.users.theater = (import ./user.nix) { pkgs=pkgs; };
    
    programs.zsh.enable = true; # Enable ZSH system-wide

    services.pcscd.enable = true; # system-wide pcscd enable

    # not packages per se, but this is what gives us virtualbox
    virtualisation.virtualbox.host.enable = true;
    users.extraGroups.vbox.members = [ "theater" ];

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
    home-manager.users.theater = (import ./home.nix) { 
      pkgs=pkgs; 
      lib=lib;

      # configs
      dconf = {
        settings = {
          "org/gnome/desktop/background" = {
            picture-uri-dark = "file://${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.src}";
          };
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
          };
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
      ++ [
          pkgs.dmenu
          pkgs.element-desktop
          pkgs.feh
          pkgs.firefox
          pkgs.remmina
          pkgs.thunderbird
          pkgs.vlc
          pkgs.yubioath-flutter
      ];
    };
    

    # installed packages
}
