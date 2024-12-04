{ config, lib, pkgs, ... }:
let 
  contport = (import ../util/portpattern.nix);
in
{
  containers.web = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "10.10.32.10";
    localAddress = "10.10.32.11";

    forwardPorts =
      (contport 80)    # HTTP
    ++(contport 443)   # HTTPS
    ++(contport 2222)  # SSH
    ++(contport 1234); # ZNC

    config = { config, pkgs, ...}: {
      networking.firewall.enable = true;
      networking.firewall.allowedTCPPorts = [ 80 443 ];
      networking.firewall.allowPing = true;

      users.users.manager = {
        isNormalUser = true;
        createHome = true;
        openssh.authorizedKeys.keys = (import ../users/fred/ssh_keys.nix);
        extraGroups = [ "wheel" "git" "nginx" ];
      };

      users.users.git = {
        isSystemUser = true;
        group = "git";
        home = "/var/lib/git-server";
        createHome = true;
        shell = "${pkgs.git}/bin/git-shell";
        openssh.authorizedKeys.keys = (import ../users/fred/ssh_keys.nix);
      };

      users.users.cgit = {
        extraGroups = [ "git" ];
      };

      users.groups.git = {};

      services.cgit.public = {
        enable = true;
        nginx.virtualHost = "git.fpf3.net";
        scanPath = "/var/lib/git-server";
        user = "cgit";
      };

      services.nginx = {
        enable = true;

        virtualHosts."git.fpf3.net" = {
          forceSSL = true;
          enableACME = true;
        };

        virtualHosts."jellyfin.fpf3.net" = {
          locations."/".proxyPass = "http://10.10.31.10:8096"; 
          forceSSL = true;
          enableACME = true;
        };
        
        virtualHosts."invidious.fpf3.net" = {
          locations."/".proxyPass = "http://10.10.31.10:3000"; 
          forceSSL = true;
          enableACME = true;
        };
      };

      security.acme = {
        acceptTerms = true;
        defaults.email = "fred@fpf3.net";
        #defaults.server = "https://acme-staging-v02.api.letsencrypt.org/directory"; # faster renew for staging/alpha
      };

      services.openssh = {
        ports = [ 22 2222 ];
        enable = true;
        settings = {
          PasswordAuthentication = false;
          PermitRootLogin = "no";
        };

        extraConfig = ''
          Match user git
            AllowTcpForwarding no
            AllowAgentForwarding no
            PermitTTY no
            X11Forwarding no
        '';
      };

      # TLS fingerprint: dcf4acc25ffff7d449ed45f35a2409b3b527dd7f99f5caaccb30cf2e0dc90e61b38aa1fd9ce344425a72ddcee0f5450952f0cc8777b65330a9713e35b549ed00
      services.znc = {
        enable = true;
        openFirewall = true;

        modulePackages = [ pkgs.zncModules.backlog ];

        confOptions = {
          modules = [ "webadmin" "log" "backlog" ];
          userName = "fred";
          userModules = [ "chansaver" "controlpanel" ];
          nick = "fpf3";

          port = 1234;
          passBlock =''
            <Pass password>
              Method  = sha256
              Hash    = c06c463bbeb5b83657fed0c272c3a001eb5ff63b03f1a79331873cb4365fa717
              Salt    = T.3uatRUiaoK.zhhjtm7
            </Pass>
          '';

          networks.lainchan = {
            server = "irc.lainchan.org";
            port = 6697;
            useSSL = true;
            modules = [ "simple_away" "SASL" ];
            channels = [ "lainchan" ];
          };
        };
      };

      environment.systemPackages = with pkgs; [
        git
        mercurial
      ];

      system.stateVersion = "23.11";
    };
  };
}
