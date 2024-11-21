{ 
  pkgs, 
  lib, 
  userPackages, 
  fullName ? "", 
  emailAddr ? "", 
  dconf ? {}, 
  gtk ? {}, 
  pointerCursor ? {}, 
  envVars ? {}, 
  ...
}:
{
  home.stateVersion = "24.05"; # Do I bump this, or keep it the same?

  # configs
  programs = {
    git = lib.mkIf(fullName != "") {
        enable = true;
        userName = fullName;
        userEmail = emailAddr;
    };

    mercurial = lib.mkIf(fullName != "") {
        enable = true;
        userName = fullName;
        userEmail = emailAddr;
    };

    zsh = (import ../zsh/zsh.nix) { lib=lib; envVars = envVars; };

    tmux = (import ../tmux/tmux.nix);

    vim = (import ../vim/vim.nix) { pkgs=pkgs; lib=lib; };
  };

  xresources.properties = {
    "st.alpha" = "1.0";
  };

  programs.bash.sessionVariables = lib.mkIf(envVars != {}) envVars;

  dconf = lib.mkIf(dconf != {}) dconf;
  gtk = lib.mkIf(gtk != {}) gtk;
  home.pointerCursor = lib.mkIf (pointerCursor != {}) pointerCursor;
  home.packages = userPackages;
}
