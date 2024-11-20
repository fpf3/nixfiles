{
  enable = true;
  settings = {
    interval = 1; # check every second
    idle_time = 30; # down for 30 seconds? shut 'er down
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
}
