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

    zsh = (import ../../frags/zsh/zsh.nix);

    tmux = (import ../../frags/tmux/tmux.nix);

    vim = (import ../../frags/vim/vim.nix) { pkgs=pkgs; lib=lib; };
  };

  xresources.properties = {
    "st.alpha" = "1.0";
  };

  dconf = lib.mkIf(dconf != {}) dconf;
  gtk = lib.mkIf(gtk != {}) gtk;
  home.pointerCursor = lib.mkIf (pointerCursor != {}) pointerCursor;
  home.packages = userPackages;
}
