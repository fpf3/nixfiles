{ pkgs, lib, userPackages, dconf ? {}, gtk ? {}, pointerCursor ? {}, ...}:
{
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

    vim = (import ./vim.nix) { pkgs=pkgs; };
  };

  dconf = lib.mkIf(dconf != {}) dconf;
  gtk = lib.mkIf(gtk != {}) gtk;
  home.pointerCursor = lib.mkIf (pointerCursor != {}) pointerCursor;
  home.packages = userPackages;
}
