{ config, lib, pkgs, ... }:
{
  containers.jellyfin = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "10.10.31.10";
    localAddress = "10.10.31.11";

    forwardPorts = [
    ## Jellyfin ports...
        {
          containerPort = 8096;
          hostPort = 8096;
          protocol = "tcp";
        }
        {
          containerPort = 8920;
          hostPort = 8920;
          protocol = "tcp";
        }
        {
          containerPort = 1900;
          hostPort = 1900;
          protocol = "udp";
        }
        {
          containerPort = 7359;
          hostPort = 7359;
          protocol = "udp";
        }
    ## SMB ports...
        {
          containerPort = 139;
          hostPort = 139;
          protocol = "tcp";
        }
        {
          containerPort = 445;
          hostPort = 445;
          protocol = "tcp";
        }
        {
          containerPort = 137;
          hostPort = 137;
          protocol = "udp";
        }
        {
          containerPort = 138;
          hostPort = 138;
          protocol = "udp";
        }
    ## SMB-WSDD ports...
        {
          containerPort = 3702;
          hostPort = 3702;
          protocol = "udp";
        }
        {
          containerPort = 5357;
          hostPort = 5357;
          protocol = "udp";
        }
    ];

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
        securityType = "auto";
        openFirewall = true;
        extraConfig = ''
            workgroup = WORKGROUP
            allow insecure wide links = yes
            map to guest = bad user
            guest account = guest
            follow symlinks = yes
            wide links = yes
            unix extensions = no
          '';
        shares = {
          public = {
              path = "/mnt/shares/jellyfin";
              browseable = "yes";
              "read only" = "no";
              "guest ok" = "yes";
          };
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
