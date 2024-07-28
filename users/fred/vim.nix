# For use with home-manager
# Spits out a collection that can be put in 
#   home-manager.users.<user>.programs.vim

{ pkgs }:
{
        enable = true;
        defaultEditor = true;
        plugins = with pkgs.vimPlugins; 
        [
            vim-colorschemes
            nerdtree
        ];
        extraConfig = 
        ''
        syntax enable

        let g:auto_save = 1 " enable autosave on startup
        let g:auto_save_silent = 1 " shut up about it
        let g:auto_save_event = ["InsertLeave", "TextChanged"]

        syntax on
        colorscheme zenburn
        set nu!
        set relativenumber!

        set ai!
        set tabstop=4
        set expandtab

        set wildmenu
        set wildmode=list:longest,full

        command! -range=% -nargs=0 Tab2Space execute '<line1>,<line2>s#^\t\+#\=repeat(" ", len(submatch(0))*' . &ts . ')'
        command! -range=% -nargs=0 Space2Tab execute '<line1>,<line2>s#^\( \{'.&ts.'\}\)\+#\=repeat("\t", len(submatch(0))/' . &ts . ')'
        command W w

        vnoremap <C-c> "+y
        inoremap <C-v> <Esc>"+gPi
        nmap <C-s> :w<Return>
        nmap <C-S-e> <Esc>:NERDTreeToggle<CR>
        nmap <C-S-t> <Esc>:NERDTreeFocus<CR>

        nmap <C-j> LjM
        nmap <C-k> HkM

        nmap o :e 
        nmap O :tabnew 

        nmap J gT
        nmap K gt

        nmap <Space> @q

        set shiftwidth=4
        set foldmethod=indent
        set foldnestmax=10
        set nofoldenable
        set foldlevel=1	
        set mouse=a
        '';
}
