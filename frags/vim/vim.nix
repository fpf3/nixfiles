# For use with home-manager
# Spits out a collection that can be put in 
#   home-manager.users.<user>.programs.vim

{ pkgs, lib }:
let
  coc_keybinds  = builtins.path { path=./coc_keybinds.vim; };
in
{
        enable = true;
        defaultEditor = true;
        plugins = with pkgs.vimPlugins; 
        [
            vim-colorschemes
            nerdtree
            coc-nvim
            coc-rust-analyzer
            coc-clangd
            coc-pyright
        ];
        extraConfig = builtins.replaceStrings
          ["COC_KEYBINDS_PATH"]
          [coc_keybinds]
          (lib.readFile ./vimrc);
}
