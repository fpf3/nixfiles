{ pkgs, lib, ...}:
{
  as = pkgs.writeShellScriptBin "autostart.sh" (lib.readFile ./scripts/autostart.sh);

  as_blocking = pkgs.writeShellScriptBin "autostart_blocking.sh" (lib.readFile ./scripts/autostart_blocking.sh);

  statusbar = pkgs.writeShellScriptBin "statusbar" (lib.readFile ./scripts/statusbar);

  snip = pkgs.writeShellScriptBin "snip" (lib.readFile ./scripts/snip);
  
  xsandbox = pkgs.writeShellScriptBin "xsandbox" (lib.readFile ./scripts/xsandbox);
  
  dmenu_spawn = pkgs.writeShellScriptBin "dmenu_spawn" (lib.readFile ./scripts/dmenu_spawn.sh);

  pyman = pkgs.writeShellScriptBin "pyman" (lib.readFile ./scripts/pyman);
}
