{
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
    
    # pane hiding
    bind-key u command-prompt -p "join pane from:"  "join-pane -s '%%'"
    bind-key U command-prompt -p "send pane to:"  "join-pane -t '%%'"
    '';
}
