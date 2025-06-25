{ config, lib, pkgs, ... }:
let
  dm_bg = builtins.path { path=../grub/zentree_1.png; };
in
{
  services.xserver.displayManager.lightdm = {
    enable = true;
    background = dm_bg;
    greeters.lomiri.enable = true;
    #extraConfig = ''
    #  auth    sufficient   pam_fprintd.so
    #'';
  };
  services.displayManager.defaultSession = "none+dwm";
}
