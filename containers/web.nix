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
        home = "/home/fred";
        createHome = true;
        openssh.authorizedKeys.keys = (import ../users/fred/ssh_keys.nix);
      };

      users.users.git = {
        isSystemUser = true;
        group = "git";
        home = "/var/lib/git-server";
        createHome = true;
        shell = "${pkgs.git}/bin/git-shell";
        openssh.authorizedKeys.keys = (import ../users/fred/ssh_keys.nix);
      };

      users.groups.git = {};

      services.cgit.public = {
        enable = true;
        scanPath = "/var/lib/git-server";
      };

      services.openssh = {
        ports = [ 22 2222 ];
        enable = true;
        extraConfig = ''
        Match user git
        AllowTcpForwarding no
        AllowAgentForwarding no
        PasswordAuthentication no
        PermitTTY no
        X11Forwarding no
        '';
      };

      environment.systemPackages = with pkgs; [
        git
      ];

      system.stateVersion = "24.05";
    };
  };
}
