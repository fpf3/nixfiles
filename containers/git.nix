{ config, lib, pkgs, ... }:
let 
  contport = (import ../util/portpattern.nix);
  serverDomain = "dwn-rnd-id15.ogp.qvii.com";
in
{
  containers.gitserver = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "10.10.32.10";
    localAddress = "10.10.32.11";

    timeoutStartSec = "5min"; # gitlab takes a LOOOONG time

    forwardPorts =
      (contport 80)    # HTTP
    ++(contport 443)   # HTTPS
    ++(contport 2222); # SSH

    config = { config, pkgs, ...}: {
      networking.firewall.enable = false;
      networking.defaultGateway = {
        address = "10.10.32.10";
        interface = "eth0";
      };

      users.users.manager = {
        isNormalUser = true;
        createHome = true;
        openssh.authorizedKeys.keys = (import ../users/fred/ssh_keys.nix);
        extraGroups = [ "wheel" "git" "nginx" ];
      };

      users.users.git = {
        isSystemUser = true;
        group = "git";
        home = "/home/git";
        createHome = true;
        shell = "${pkgs.git}/bin/git-shell";
        openssh.authorizedKeys.keys = (import ../users/fred/ssh_keys.nix) 
        ++ [
          "ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBADP4oB4swh08G+evgsWf3qoF9iFenE7VbpDZDX5kgqjWac6/oDaqIY29NhtLUn8ANEA2Xpjv09VDXrRf2S2mCq40gEcI3zUs9NuAjWRHUDAy14uJ1x1My5z1QJtaMIKd3kcToRms8WDhAL7K25vOSwPJ3RiH8j3MJdCMP1QMiHW7hn5YA== ffrey@DWN-RND-ID15"
          ];
      };

      users.groups.git = {};

      services.nginx = {
        enable = true;

        recommendedProxySettings = true;

        virtualHosts.${serverDomain} = {
          forceSSL = false;
          enableACME = false;
          #locations."/".proxyPass = "http://unix:/run/gitlab/gitlab-workhorse.socket";
          locations."/".proxyPass = "http://localhost:3001/";
        };

        gitweb = {
          enable = true;
          virtualHost = serverDomain;
        };
      };

      users.users.nginx.extraGroups = [ "gitea" ];
      services.gitweb.projectroot = "/var/lib/gitea/repositories/";

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

      services.gitlab = {
        enable = false;
        databasePasswordFile = "/var/gitlab/dbPassword";
        initialRootPasswordFile = "/var/gitlab/rootPassword";
        initialRootEmail = "admin@local.host";
        secrets = {
          secretFile = "/var/gitlab/secret";
          otpFile =    "/var/gitlab/otpsecret";
          dbFile =     "/var/gitlab/dbsecret";
          jwsFile =    "/var/gitlab/oidcKeyBase";
        };

        extraConfig = {
          ldap = {
            enabled = true;
            servers.main = {
              label = "qvildap";
              host = "swn-ad01.qvii.net";
              port = 636;
              uid = "sAMAccountName";
              encryption = "simple_tls";
              #tls_options = {
              #  ca_file = "/var/gitlab/ldap.pem";
              #};
              base = "dc=qvii,dc=net";
              user_filter = "";
              group_base = "ou=SW_Repo_Access,dc=swn-ad01,dc=qvii,dc=net";
              allow_username_or_email_login = true;
            };
          };
        };
      };

      services.gitea = {
        enable = true;
        appName = "QVI Gitea";
        settings.server = {
          DOMAIN = serverDomain;
          ROOT_URL = "http://${config.services.gitea.settings.server.DOMAIN}/";
          HTTP_PORT = 3001;
        };
      };
      
      environment.systemPackages = with pkgs; [
        git
        gitlab
        openssl
      ];

      system.stateVersion = "24.05";
    };
  };
}
