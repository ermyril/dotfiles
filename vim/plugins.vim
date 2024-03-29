filetype off                  " required

" Installing vim-plug if it's not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Helper function to include plugins depends on condition 
function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

" Vim-Plug config https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/bundle')
" Make sure you use single quotes

"Plug 'VundleVim/Vundle.vim'
Plug 'tpope/vim-vinegar'
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'ctrlpvim/ctrlp.vim'
"Plug 'rking/ag.vim'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
"jsx support
Plug 'tpope/vim-obsession'
Plug 'ervandew/supertab'
"Plug 'garbas/vim-snipmate'
Plug 'SirVer/ultisnips', Cond(has('python3'))

Plug 'mattn/emmet-vim'
"Plug 'terryma/vim-multiple-cursors'

"Trying to fix bad php support
Plug '2072/PHP-Indenting-for-VIm'
Plug 'StanAngeloff/php.vim'
Plug 'captbaritone/better-indent-support-for-php-with-html'

Plug 'christoomey/vim-tmux-navigator'
Plug 'jiangmiao/auto-pairs'

" Themes
Plug 'mhartington/oceanic-next'
"Plug 'ghifarit53/tokyonight-vim'
Plug 'dracula/vim', { 'as': 'dracula' }

" Syntax support
Plug 'sheerun/vim-polyglot'
Plug 'editorconfig/editorconfig-vim'
"jsx support
"Plug 'pangloss/vim-javascript'
"Plug 'mxw/vim-jsx'

"Plug 'jwalton512/vim-blade'
"Plug 'digitaltoad/vim-pug'

"Plug 'mustache/vim-mustache-handlebars'

" Nix syntax support
Plug 'LnL7/vim-nix'

"Goddammit how I was living without it
"
Plug 'tpope/vim-commentary'
Plug 'psliwka/vim-smoothie'

" include neovim plugins
source ~/.dotfiles/vim/nvim-plugins.vim

" All of your Plugins must be added before the following line
call plug#end()


" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

