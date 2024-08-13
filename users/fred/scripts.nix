{ pkgs, lib, ...}:
{
  as = pkgs.writeShellScriptBin "autostart.sh" (lib.readFile ./scripts/autostart.sh);

  as_blocking = pkgs.writeShellScriptBin "autostart_blocking.sh" (lib.readFile ./scripts/autostart_blocking.sh);

  statusbar = pkgs.writeShellScriptBin "statusbar" (lib.readFile ./scripts/statusbar);

  snip = pkgs.writeShellScriptBin "snip" (lib.readFile ./scripts/snip);
}
