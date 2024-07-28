{ config, lib, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
  fpf3_dwm = pkgs.callPackage /home/fred/dev/dwm/default.nix {};
in
{
    imports = 
    [
        (import "${home-manager}/nixos")
    ];
    
    services.pcscd.enable = true; # system-wide pcscd enable
    services.xserver.windowManager.dwm.package = pkgs.callPackage /home/fred/dev/dwm/default.nix {};

    users.users.fred = {
        isNormalUser = true;
        group = "wheel";
        openssh.authorizedKeys.keys = [
            "ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBAAjcQkkC8c1kUpG7xE50vulmoZNjQTpDwPeNgZ/QFkOh9mbx7JR/dA4jtIAVOLDeLqgCli9J9QP8mueo2r85BqB4wGkVLBiy+csasdHv/KStZ5KT8wFV8RhuBEz13utNlsexZyDwefkHD9Otpal/yn5RqE8ZD3Zj9W2E/xpaNjJ/ZPY8g== fred"
            "ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBAHtCf8s9k4fTsKtypEOYhyBAAvQwZF+gujkmGI9maFk9MAFbypX6ZVPPM5GBMkN20CjvfsVSmnIJzOiyhVMk9dWcQC2XObsNsR2+AiEsLoUzb8JJwJMTSTX5VTrzPQc44X6wJBNjUFDkCY9xy2quNwLVMf7EBmDExawGf8gOytWfqk7EQ== fred"
            "ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBAEarOXdYBNvRWAM7au2yCiqGsKvvYfYEjWGCgaFFp1KuvsKKBKcoOsZl2ic56T9BNpZ+FVs6gU+4TisCrz0JPRAOAFrvJeg429kZCgA7GsIX5dOMa9H01M9raFd5Wqmb3cBibcVUm7VcW99gqGrbJB3J2dMGSb/1nU1RzG5xIXe3qIJbg== fred"
        ];

        shell = pkgs.zsh;
        #packages = [ pkgs.dwm ];
    };

    # not packages per se, but this is what gives us virtualbox
    virtualisation.virtualbox.host.enable = true;
    users.extraGroups.vbox.members = [ "fred" ];

    # steam system config
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };
    
    programs.zsh.enable = true; # Enable ZSH system-wide

    qt = {
      enable = true;
      platformTheme = "gnome";
      style = "adwaita-dark";
    };
    # Home Manager
    home-manager.users.fred = {
      home.stateVersion = "24.05"; # Do I bump this, or keep it the same?

        # configs
        programs = {
            git = {
                enable = true;
                userName = "Fred Frey";
                userEmail = "fred@fpf3.net";
            };

            mercurial = {
                enable = true;
                userName = "Fred Frey";
                userEmail = "fred@fpf3.net";
            };

            zsh = {
                enable = true;
                #antidote.enable = true;
                #antidote.plugins = [ ohmyzsh/ohmyzsh ];
                oh-my-zsh = {
                    enable = true;
                    theme = "half-life";
                };
                autocd = true;
                initExtra = ''
                  #NIX_AUTO_RUN = "1"
                  PATH=$PATH:/home/fred/bin
                '';
            };

            tmux = {
              enable = true;
              clock24 = true;
              mouse = true;
              keyMode = "vi";
              terminal = "xterm-256color";
              extraConfig = ''
                # split panes using | and -
                bind | split-window -h
                bind - split-window -v
                # reload config
                bind r source-file ~/.tmux.conf
                # pane selection
                bind h select-pane -L
                bind j select-pane -D
                bind k select-pane -U
                bind l select-pane -R
                '';
            };

            # vim config in `fredvim.nix`
            vim = import ./vim.nix { pkgs=pkgs; };
        };

        dconf.settings = {
          "org/gnome/desktop/background" = {
            picture-uri-dark = "file://${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.src}";
          };
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
          };
        };

        gtk = {
          enable = true;
          theme = {
            name = "Adwaita-dark";
            package = pkgs.gnome.gnome-themes-extra;
          };
        };


        home.pointerCursor = {
          gtk.enable = true;
          x11.enable = true;
          name = "Adwaita";
          size=16;
          package = pkgs.gnome.adwaita-icon-theme;
        };

        # installed packages
        home.packages = [
            fpf3_dwm
            pkgs.bc
            pkgs.dmenu
            pkgs.element-desktop
            pkgs.fd
            pkgs.feh
            pkgs.firefox
            pkgs.gnumake
            pkgs.htop
            pkgs.htop
            pkgs.lm_sensors
            pkgs.lukesmithxyz-st
            pkgs.ncdu
            pkgs.openfortivpn
            pkgs.ranger
            pkgs.remmina
            pkgs.ripgrep
            pkgs.rofi
            pkgs.rofimoji
            pkgs.sysstat
            pkgs.thunderbird
            pkgs.tmux
            pkgs.tree
            pkgs.vesktop
            pkgs.vlc
            pkgs.wget
            pkgs.xclip
            pkgs.yubikey-manager
            pkgs.yubioath-flutter
            pkgs.zsh
        ];
    };
}
