{ config, lib, pkgs, ... }:
let
  dm_bg = builtins.path { path=../grub/zentree_1.png; };
in
{
  services.xserver.displayManager.lightdm = {
    enable = true;
    background = dm_bg;
    greeters.enso.enable = true;
    extraConfig = ''
      display-setup-script=xrandr --output DP-0 --primary
    '';
  };
}
