{ config, lib, pkgs, ... }:
{
  containers.web = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "10.10.33.10";
    localAddress = "10.10.33.11";

    forwardPorts = [
      # SMTP
      {
        containerPort = 25;
        hostPort = 25;
        protocol = "udp";
      }
      {
        containerPort = 25;
        hostPort = 25;
        protocol = "tcp";
      {
        containerPort = 465;
        hostPort = 465;
        protocol = "udp";
      }
      {
        containerPort = 465;
        hostPort = 465;
        protocol = "tcp";
      }
      {
        containerPort = 587;
        hostPort = 587;
        protocol = "udp";
      }
      {
        containerPort = 587;
        hostPort = 587;
        protocol = "tcp";
      }
      # IMAP
      {
        containerPort = 143;
        hostPort = 143;
        protocol = "udp";
      }
      {
        containerPort = 143;
        hostPort = 143;
        protocol = "tcp";
      }
      {
        containerPort = 993;
        hostPort = 993;
        protocol = "udp";
      }
      {
        containerPort = 993;
        hostPort = 993;
        protocol = "tcp";
      }
    ];

    config = { config, pkgs, ...}: {
      networking.firewall.enable = true;
      networking.firewall.allowedTCPPorts = [ 25 587 465 143 993 ];
      networking.firewall.allowPing = true;

      users.users.manager = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = (import ../users/fred/ssh_keys.nix);
      };

      services.maddy = {
        enable = true;
        primaryDomain = "mail2.fpf3.net";
        
        tls = {
          loader = "acme";
          extraConfig = ''
            email fred@mail2.fpf3.net
            agreed # indicate your agreement with Let's Encrypt ToS
            host ${config.services.maddy.primaryDomain};
            challenge dns-01
            dns gandy {
              api_token "{env:GANDI_API_KEY}"
            }
          '';
        };

        # Enable TLS listeners. Configuring this via the module is not yet
        # implemented, see https://github.com/NixOS/nixpkgs/pull/153372
        config = builtins.replaceStrings [
        "imap tcp://0.0.0.0:143"
        "submission tcp://0.0.0.0:587"
        ] [
        "imap tls://0.0.0.0:993 tcp://0.0.0.0:143"
        "submission tls://0.0.0.0:465 tcp://0.0.0.0:587"
        ] options.services.maddy.config.default;
        # Reading secrets from a file. Do not use this example in production
        # since it stores the keys world-readable in the Nix store.
        secrets = [ "${pkgs.writeText "secrets" ''
        GANDI_API_KEY=1234
        ''}" ];

        ensureAccounts = [
          "fred@mail2.fpf3.net"
        ];


      };

      security.acme = {
        acceptTerms = true;
        defaults.email = "fred@fpf3.net";
        #defaults.server = "https://acme-staging-v02.api.letsencrypt.org/directory"; # faster renew for staging/alpha
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
        mercurial
      ];

      system.stateVersion = "23.11";
    };
  };
}
