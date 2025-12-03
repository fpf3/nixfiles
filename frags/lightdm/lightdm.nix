{ config, lib, pkgs, ... }:
let
  dm_bg = builtins.path { path=../grub/zentree_1.png; };
in
{
  services.xserver.displayManager.lightdm = {
    enable = true;
    background = dm_bg;
    greeters.slick = {
      enable = true;
      extraConfig = ''
        background=${dm_bg}
        enable-hidpi=off
      '';
    };

    #greeter.package = pkgs.callPackage /home/fred/dev/nixpkgs/pkgs/by-name/li/lightdm-slick-greeter/package.nix {};
  };
  
  environment.systemPackages = with pkgs; [
    xorg.xhost
    dconf
    orca
    gdk-pixbuf
    gobject-introspection
    wrapGAppsHook3
    (python3.withPackages (ps: with ps; [
      pygobject3
    ]))
  ];
}
