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
      (import ../../frags/gamer/gamer.nix { inherit pkgs lib config withGui; })
    ];
    
    users.users.fred = (import ./user.nix) { inherit pkgs; };
    
    programs.zsh.enable = true; # Enable ZSH system-wide

    services.pcscd.enable = true; # system-wide pcscd enable
    
    services.xserver.windowManager.dwm.package = lib.mkIf(withGui) fpf3_dwm;

    services.syncthing = lib.mkIf(withGui){
      enable = true;
      user = "${username}";
      configDir = "/home/${username}/.config/syncthing";
    };

    # not packages per se, but this is what gives us virtualbox
    users.extraGroups.vboxusers.members = lib.mkIf(withGui) [ "${username}" ];

    qt = lib.mkIf(withGui) {
      enable = true;
      platformTheme = "kde";
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

      gtk = lib.mkIf(withGui) rec {
        enable = true;
        theme = {
          name = "Adwaita-dark";
          package = pkgs.gnome-themes-extra;
        };
        gtk4.theme = theme;
      };
      
      pointerCursor = lib.mkIf(withGui) {
        enable = true;
        gtk.enable = true;
        x11.enable = true;
        name = "Bibata-Modern-Classic";
        size=16;
        package = pkgs.mint-cursor-themes;
      };

      # installed packages

      userPackages = 
      listIf(withGui) (
           (import ../../frags/pkgs/gui.nix { inherit pkgs; })
        ++ (import ../../frags/pkgs/chatter.nix { inherit pkgs; })
        ++ (import ../../frags/pkgs/gamer.nix { inherit pkgs; })
        ++ (import ../../frags/pkgs/typesetting.nix { inherit pkgs; })
        ++ (import ../../frags/pkgs/custom.nix { inherit pkgs; })
        ++ (import ../../frags/pkgs/gui_utils.nix { inherit pkgs; })
        ++ (import ../../frags/pkgs/wine.nix { inherit pkgs; })
      )
      ++ (import ../../frags/pkgs/general_dev.nix { inherit pkgs; })
      ++ (import ../../frags/pkgs/py_dev.nix { inherit pkgs; })
      ++ (import ../../frags/pkgs/scripts.nix { inherit pkgs; })
      ++ (import ../../frags/pkgs/utils.nix { inherit pkgs; });
    };
}
