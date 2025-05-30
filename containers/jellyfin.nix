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
      (contport 8096)   # Jellyfin
    ++(contport 8920)
    ++(contport 1900)
    ++(contport 7359)
    ++(contport 139)    # SMB
    ++(contport 445)
    ++(contport 137)
    ++(contport 138)
    ++(contport 3702)   # SMB-WSDD
    ++(contport 5357)
    ++(contport 3000);  # invidious


    config = { config, pkgs, ...}: {
      users.users.manager = {
        isNormalUser = true;
        homeMode = "777";
      };
      networking.firewall.enable = true;
      networking.firewall.allowedTCPPorts = [ 8096 8920 1900 7359 6882 3000 ];
      networking.firewall.allowPing = true;

      services.openssh.enable = true;

      environment.systemPackages = with pkgs; [
        jellyfin
        jellyfin-web
        jellyfin-ffmpeg
        ffmpeg-full
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

      services.invidious = {
        enable = true;

        sig-helper.enable = true;
        http3-ytproxy.enable = true;

        settings = {
          db = {
            user = "invidious";
            dbname = "invidious";
          };

          hmac_key = "yi7beiCiaPaeneWeuc0e";

          visitor_data = "CgtCMjJYWC1OWG91Zyiirr-6BjIKCgJVUxIEGgAgGw%3D%3D";
          po_token = "MnQLcWu2RBegKQtJdSADtwjZpc-TsVkUzkr8AYrZr55Qse3Lw3iwgBsZT6lL041ozeJecZRI-sxPKpBYgA1tfaFM2klI-lHKR7ae6mkR2fpLOtKepXfYaLoduWgHIdCVpPOXn6FruwZGzWCFBbhHRrhI4mFQBw==";
        };
      };

      services.postgresql = {
        enable = true;
        ensureUsers = [
          { name = "invidious"; ensureDBOwnership = true; }
        ];
        ensureDatabases = [
          "invidious"
        ];
      };

      system.stateVersion = "23.11";
    };
  };
}
