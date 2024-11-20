{ config, lib, pkgs, ... }:
{
  containers.web = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "10.10.32.10";
    localAddress = "10.10.32.11";

    forwardPorts = [
      # HTTP
      {
        containerPort = 80;
        hostPort = 80;
        protocol = "udp";
      }
      {
        containerPort = 80;
        hostPort = 80;
        protocol = "tcp";
      }
      # HTTPS
      {
        containerPort = 443;
        hostPort = 443;
        protocol = "udp";
      }
      {
        containerPort = 443;
        hostPort = 443;
        protocol = "tcp";
      }
      # SSH
      {
        containerPort = 2222;
        hostPort = 2222;
        protocol = "udp";
      }
      {
        containerPort = 2222;
        hostPort = 2222;
        protocol = "tcp";
      }
    ];

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

      environment.systemPackages = with pkgs; [
        git
        mercurial
      ];

      system.stateVersion = "24.05";
    };
  };
}
