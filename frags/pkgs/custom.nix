{ pkgs }:
let
  fpf3_dwm = pkgs.callPackage ../../custom_pkgs/dwm/default.nix {};
  fpf3_st = pkgs.callPackage ../../custom_pkgs/st/default.nix {};
in
  [
    fpf3_dwm
    fpf3_st
  ]
