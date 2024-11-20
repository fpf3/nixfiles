{ config, lib, pkgs, withGui ? true }:
let
  username = "fred";
  fpf3_dwm = pkgs.callPackage ../../custom_pkgs/dwm/default.nix {};
  listIf = (cond: l: if cond then l else []);
in
{
    imports = 
    [
      <home-manager/nixos>
      (import ../../frags/gamer/gamer.nix {pkgs=pkgs; lib=lib; config=config; withGui=withGui;})
    ];
    
    users.users.fred = (import ./user.nix) { pkgs=pkgs; };
    
    programs.zsh.enable = true; # Enable ZSH system-wide

    services.pcscd.enable = true; # system-wide pcscd enable
    
    services.xserver.windowManager.dwm.package = lib.mkIf(withGui) fpf3_dwm;

    services.syncthing = lib.mkIf(withGui){
      enable = true;
      user = "${username}";
      configDir = "/home/${username}/.config/syncthing";
    };

    # not packages per se, but this is what gives us virtualbox
    virtualisation.virtualbox.host.enable = lib.mkIf(withGui) true;
    users.extraGroups.vbox.members = lib.mkIf(withGui) [ "${username}" ];

    # give me the man pages... christ
    documentation.dev.enable = true;

    qt = lib.mkIf(withGui) {
      enable = true;
      platformTheme = "gnome";
      style = "adwaita-dark";
    };

    # Home Manager
    home-manager.users.fred = (import ../../frags/home/home.nix) { 
      pkgs=pkgs; 
      lib=lib;

      fullName = "Fred Frey";
      emailAddr = "fred@fpf3.net";

      # configs
      dconf = lib.mkIf(withGui) {
        settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
          };
        };
      };

      gtk = lib.mkIf(withGui) {
        enable = true;
        theme = {
          name = "Adwaita-dark";
          package = pkgs.gnome-themes-extra;
        };
      };
      
      pointerCursor = lib.mkIf(withGui) {
        gtk.enable = true;
        x11.enable = true;
        name = "Adwaita";
        size=16;
        package = pkgs.adwaita-icon-theme;
      };

      # installed packages

      userPackages = 
        listIf(withGui) (import ../../frags/pkgs/gui.nix { pkgs=pkgs; })
      ++(import ../../frags/pkgs/custom.nix { pkgs=pkgs; })
      ++(import ../../frags/pkgs/general_dev.nix { pkgs=pkgs; })
      ++(import ../../frags/pkgs/py_dev.nix { pkgs=pkgs; })
      ++(import ../../frags/pkgs/scripts.nix { pkgs=pkgs; })
      ++(import ../../frags/pkgs/utils.nix { pkgs=pkgs; })
      ++(import ../../frags/gamer/pkgs.nix { pkgs=pkgs; });
    };
    

    # installed packages
}
