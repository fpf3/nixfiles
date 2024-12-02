{ config, lib, pkgs, ... }:
let 
  contport = (import ../util/portpattern.nix);
in
{
  containers.jellyfin = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "10.10.31.10";
    localAddress = "10.10.31.11";

    forwardPorts = 
      (contport 8096) # Jellyfin
    ++(contport 8920)
    ++(contport 1900)
    ++(contport 7359)
    ++(contport 139) # SMB
    ++(contport 445)
    ++(contport 137)
    ++(contport 138)
    ++(contport 3702) # SMB-WSDD
    ++(contport 5357);


    config = { config, pkgs, ...}: {
      users.users.manager = {
        isNormalUser = true;
        homeMode = "777";
      };
      networking.firewall.enable = true;
      networking.firewall.allowedTCPPorts = [ 8096 8920 1900 7359 6882 ];
      networking.firewall.allowPing = true;

      services.openssh.enable = true;

      environment.systemPackages = with pkgs; [
        jellyfin
        jellyfin-web
        jellyfin-ffmpeg
        deluge
      ];

      services.jellyfin = {
        enable = true;
        openFirewall = true;
      };

      services.samba = {
        enable = true;
        openFirewall = true;
        settings.global = {
          securtiy = "auto";
          "unix extensions" = "no";
        };

        settings.public = {
          browseable = "yes";
          "guest ok" = "yes";
          "guest account" = "guest";
          path = "/mnt/shares/jellyfin";
          "read only" = "no";
          "follow symlinks" = "yes";
          "wide links" = "yes";
          "allow insecure wide links" = "yes";

          #"map to guest" = "bad user";
        };
      };

      services.samba-wsdd = {
        enable = true;
        openFirewall = true;
      };

      system.stateVersion = "23.11";
    };
  };
}
