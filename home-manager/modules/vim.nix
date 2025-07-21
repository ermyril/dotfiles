{ config, lib, pkgs, ... }:

let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in {
  programs.vim = {
    enable = true;
    packageConfigurable = if isDarwin then pkgs.vim-darwin else pkgs.vim-full;
    plugins = with pkgs.vimPlugins; [
      vim-vinegar
      nerdtree
      lightline-vim  # Replace vim-airline with lightline
      ctrlp-vim
      #tlib_vim
      vim-surround
      #vim-fugitive # git wrapper
      vim-obsession
      supertab # maybe not needed
      ultisnips
      auto-pairs
      vim-tmux-navigator
      vim-polyglot
      editorconfig-vim
      vim-nix
      vim-smoothie
      vim-commentary
    ];
    settings = { 
      ignorecase = true;
    };
    extraConfig = ''
      set nocompatible
      syntax enable
      language messages C
      
      " Platform-specific clipboard settings
      ${if isDarwin then "set clipboard=unnamed" else "set clipboard=unnamedplus"}
      
      set mouse=a
      set backspace=indent,eol,start				"Make backspace behave like every other editor
      let mapleader = ','					"The default leader is \, but a comma is much better

      set number						"Activate line numbers
      set linespace=15					"Macvim-specific line-height
      set autowriteall 					"Automatically write the fole then switching buffers.

      "set ttymouse=xterm2                                     
      set mouse=a                                             "Activate mouse support

      " setting timeouts
      " got this from this reddit post 
      " https://www.reddit.com/r/vim/comments/s4a3a/my_terminal_vim_is_slower_than_macvim/
      set ttimeout
      set ttimeoutlen=250
      set notimeout
      set lazyredraw
      set ttyfast


      " Tabbing
      set tabstop=8
      set expandtab
      set softtabstop=4
      set shiftwidth=4

      " Persistent undo - don't forget to create ~/.vim/undo directory
      set undofile
      set undodir=$HOME/.vim/undo
      set undolevels=1000
      set undoreload=10000


      "-------------Visuals-------------"
      if (has("termguicolors"))
          set termguicolors
      endif

      if !has("gui_running") && !has("nvim")
          set term=xterm-256color
      endif

      " Remove manual colorscheme - Stylix will handle theming
      " colorscheme OceanicNext

      "dark background
      set background=dark

      "set guifont=Fira_Code:h14				"Set the default font
      "set macligatures					"Pretty symbols
      set t_Co=256						"Use 256 colors in ter
      set linespace=15					
      set guioptions-=e					"disable system tabs

      set guioptions-=l					"Disable gui scrollbar
      set guioptions-=L
      set guioptions-=r
      set guioptions-=R

      " Remove manual highlight colors - Stylix will handle these
      " hi LineNr guibg=bg					"Background of line number panel
      " hi vertsplit guifg=bg guibg=#232526			"split bar theme

      "set insert mode indication via line
      :autocmd InsertEnter,InsertLeave * set cul!
      "-------------Search-------------"
      set hlsearch
      set incsearch




      ",------------Split Management------------"
      set splitbelow
      set splitright

      nmap <C-J> <C-W><C-J>
      nmap <C-K> <C-W><C-K>
      nmap <C-H> <C-W><C-H>
      nmap <C-L> <C-W><C-L>

      ",------------Tabs Management------------"


      nmap <Leader>n :tabedit<cr>
      nmap <Leader>1 :tabn 1<cr>
      nmap <Leader>2 :tabn 2<cr>
      nmap <Leader>3 :tabn 3<cr>
      nmap <Leader>4 :tabn 4<cr>
      nmap <Leader>5 :tabn 5<cr>


      "------------Mappings------------"

      "Make it easy to edit .vimrc file
      nmap <Leader>ev :tabedit $MYVIMRC<cr> 
      nmap <Leader>es :e ~/.dotfiles/vim/snippets/
      nmap <Leader>ep :tabedit ~/.dotfiles/vim/plugins.vim<cr>

      "Add simple highlight removal
      nmap <Leader><Space> :nohlsearch<cr>

      " Allow saving of files as sudo when I forgot to start vim using sudo.
      cmap w!! w !sudo tee > /dev/null %

      " Goto link
      nmap <Leader>g <C-]>
      nmap <Leader>b <C-O>


      "------------Plugins-----------"

      "/
      "/ Lightline
      "/
      set laststatus=2
      set noshowmode  " Hide default mode indicator since lightline shows it
      
      let g:lightline = {
            \ 'colorscheme': 'one',
            \ 'active': {
            \   'left': [ [ 'mode', 'paste' ],
            \             [ 'readonly', 'filename', 'modified' ] ],
            \   'right': [ [ 'lineinfo' ],
            \              [ 'percent' ],
            \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
            \ },
            \ 'component': {
            \   'readonly': '%{&filetype=="help"?"":&readonly?"🔒":""}',
            \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}'
            \ },
            \ 'component_visible_condition': {
            \   'readonly': '(&filetype!="help"&& &readonly)',
            \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))'
            \ }
            \ }

      "/
      "/ CtrlP
      "/

      let g:ctrlp_show_hidden = 1

      let g:ctrlp_custom_ignore = 'node_modules\|vendor\|DS_Store\|git'

      let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:30,results:30'

      "BufTags from CtrlP
      nmap <Leader>m :CtrlPBufTag<cr>

      "Most Recently from CtrlP
      nmap <Leader>mr :CtrlPMR,<cr>


      "/
      "/ NERDTree
      "/
      let NERDTreeHijackNetrw = 0
      let NERDTreeShowHidden = 1

      "Make NERDTree easier to toggle.
      nmap <Leader>t :NERDTreeToggle<cr>

      "/
      "/ CTags
      "/
      nmap <Leader>f :tag<space>

      "/
      "/ EditorConfig
      "/
      let g:indent_style = 'space'
      let g:indent_size  = 4
      let g:tab_width    = 4


      "/
      "/ SuperTab, YCM, UltiSnips
      "/

      " make YCM compatible with UltiSnips (using supertab)
      let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
      let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
      let g:SuperTabDefaultCompletionType = '<C-n>'

      " better key bindings for UltiSnipsExpandTrigger
      let g:UltiSnipsExpandTrigger = "<tab>"
      let g:UltiSnipsJumpForwardTrigger = "<tab>"
      let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"


      "/ 
      "/ Smoothie 
      "/ 
      let g:smoothie_update_interval = 10
      let g:smoothie_speed_exponentiation_factor = 0.9
      let g:smoothie_speed_linear_factor = 20

      "/ 
      "/ Autocomment 
      "/ 
      let g:inline_comment_dict = {
                  \'//': ["js", "ts", "cpp", "c", "dart", "php"],
                  \'#': ['py', 'sh'],
                  \'"': ['vim'],
                  \}
    '';
  };
}
