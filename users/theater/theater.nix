{ config, lib, pkgs, ... }:
{
    imports = 
    [
      <home-manager/nixos>
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
        package = pkgs.adwaita-icon-theme;
      };

      # installed packages

      userPackages = 
        (import ../../frags/pkgs/custom.nix { pkgs=pkgs; })
      ++(import ../../frags/pkgs/gui.nix { pkgs=pkgs; })
      ++(import ../../frags/pkgs/utils.nix { pkgs=pkgs; });
    };
    

    # installed packages
}
