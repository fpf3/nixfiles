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

  home.file.cocsettings = {
    source = ../vim/coc-settings.json;
    target = ".vim/coc-settings.json";
  };

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
    
    # package search index
    nix-index = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
    command-not-found.enable = false;

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

  # default filebrowser
  xdg.desktopEntries.dolphin = {
    name = "Dolphin";
    exec = "${pkgs.kdePackages.dolphin}/bin/dolphin";
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "dolphin.desktop" ];
      "application/x-gnome-saved-search" = [ "dolphin.desktop" ];
    };
  };

  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
  };

  programs.bash.sessionVariables = lib.mkIf(envVars != {}) envVars;

  #wayland.windowManager.hyprland = {
  #  enable = true;
  #  xwayland.enable = true;
  #  extraConfig = lib.readFile ../hyprland/hyprland.conf;
  #};

  dconf = lib.mkIf(dconf != {}) dconf;
  gtk = lib.mkIf(gtk != {}) gtk;
  home.pointerCursor = lib.mkIf (pointerCursor != {}) pointerCursor;
  home.packages = userPackages;
}
