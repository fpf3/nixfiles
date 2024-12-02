{config, pkgs, ...}: 
let 
  contport = (import ../util/portpattern.nix);
in
{
  containers.minecraft = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "10.10.30.10";
    localAddress = "10.10.30.11";

    forwardPorts = (contport 25565);

    config = { config, pkgs, ...}: {
      users.users.minecraft = {
          createHome = true;
          description = "Minecraft Server User";
          shell = "${pkgs.bash}/bin/bash";
          isNormalUser = true;
      };

      networking.firewall.enable = true;
      networking.firewall.allowedTCPPorts = [ 22 25565 ];

      services.openssh.enable = true;

      environment.systemPackages = with pkgs; [
        jre8
        jdk8
        jdk17
      ];

      systemd.services.beta173 = {
        enable = true;
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        description = "Minecraft Server (beta 1.7.3)";
        serviceConfig = {
        Type = "exec";
        User = "minecraft";
        WorkingDirectory = "/home/minecraft/b1.7.3";
        ExecStart = ''${pkgs.jdk8}/bin/java -Xms2048M -Xmx2048M -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -jar b1.7.3.jar nogui
        '';
        };
      };

      system.stateVersion = "23.11";
    };
  };
  }
