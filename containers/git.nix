{ config, lib, pkgs, ... }:
let 
  contport = (import ../util/portpattern.nix);
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
      networking.firewall.enable = true;
      networking.firewall.allowedTCPPorts = [ 80 443 2222 8080 ];
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
        user = "git";

        recommendedProxySettings = true;

        virtualHosts."172.27.168.196" = {
          forceSSL = false;
          enableACME = false;
          locations."/".proxyPass = "http://unix:/run/gitlab/gitlab-workhorse.socket";
        };

        gitweb = {
          enable = true;
          virtualHost = "172.27.168.196";
          user = "git";
        };
      };

      services.gitweb.projectroot = "/home/git";

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
        enable = true;
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
              port = 389;
              uid = "uid";
              encryption = "plain";
              base = "dc=qvii,dc=com";
              user_filter = "";
              group_base = "ou=SW_Repo_Access,dc=qvii,dc=com";
              allow_username_or_email_login = true;
            };
          };
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
