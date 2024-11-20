{ config, lib, pkgs, ... }:
{
  services.xserver.displayManager.sessionCommands = "xhost +local:";
  services.autosuspend = {
    enable = true;
    settings = {
      interval = 1; # check every second
      idle_time = 180; # down for 3 minutes? shut 'er down
    };
    
    checks = {
      RemoteUsers = {
        enabled = true;
        class = "ActiveConnection";
        ports = "22";
      };

      LocalUsers = {
        enabled = true;
        class = "XIdleTime";
        timeout = 7200; # 2 hr timeout
        method = "sockets";
        ignore_users = "gdm";
      };
    };
  };
}
