{pkgs}:
with (pkgs.callPackage ../../scripts/scripts.nix {}); [
  as
  as_blocking
  dmenu_spawn
  snip
  statusbar
  xsandbox
]
