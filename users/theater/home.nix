{ pkgs, lib, userPackages, dconf ? {}, gtk ? {}, pointerCursor ? {}, ...}:
{
  home.stateVersion = "24.05"; # Do I bump this, or keep it the same?

  # configs
  programs = {
    zsh = (import ../../frags/zsh/zsh.nix);
    
    tmux = (import ../../frags/tmux/tmux.nix);

    vim = (import ../../frags/vim/vim.nix) { pkgs=pkgs; };
  };

  dconf = lib.mkIf(dconf != {}) dconf;
  gtk = lib.mkIf(gtk != {}) gtk;
  home.pointerCursor = lib.mkIf (pointerCursor != {}) pointerCursor;
  home.packages = userPackages;
}
