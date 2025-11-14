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
let
  flag_2505 = builtins.substring 0 5 (lib.version) <= "25.05";
in
{
  home.stateVersion = "24.05"; # Do I bump this, or keep it the same?

  # configs
  programs = {
    git = lib.mkIf(fullName != "") {
      enable = true;
    }
    // lib.optionalAttrs(!flag_2505) {
      settings.user = {
        name = fullName;
        email = emailAddr;
      };
    }
    // lib.optionalAttrs(flag_2505) {
      userName = fullName;
      email = emailAddr;
    };

    mercurial = lib.mkIf(fullName != "") {
        enable = true;
        userName = fullName;
        userEmail = emailAddr;
    };
    
   ranger = {
      enable = true;
      plugins = [
        {
          name = "devicons";
          src = builtins.fetchGit {
            url = "https://github.com/alexanderjeurissen/ranger_devicons.git";
            rev = "f227f212e14996fbb366f945ec3ecaf5dc5f44b0";
          };
        }
      ];

      settings.preview_images = true;
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      tmux.enableShellIntegration = true;
    };

    bash.enable = true;

    zsh = (import ../zsh/zsh.nix) { lib=lib; envVars = envVars; };

    tmux = (import ../tmux/tmux.nix);

    vim = (import ../vim/vim.nix) { pkgs=pkgs; lib=lib; };
  };

  xresources.properties = {
    "st.alpha" = "1.0";
    "st.font" = "mono:pixelsize=15:antialias=true:autohint=true";
    "dwm.borderpx" = "2";
  };

  programs.bash.sessionVariables = lib.mkIf(envVars != {}) envVars;

  dconf = lib.mkIf(dconf != {}) dconf;
  gtk = lib.mkIf(gtk != {}) gtk;
  home.pointerCursor = lib.mkIf (pointerCursor != {}) pointerCursor;
  home.packages = userPackages;
}
