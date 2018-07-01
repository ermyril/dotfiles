filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-vinegar'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-airline/vim-airline'
Plugin 'ctrlpvim/ctrlp.vim'
"Plugin 'rking/ag.vim'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-obsession'
Plugin 'Valloric/YouCompleteMe'
Plugin 'ervandew/supertab'
"Plugin 'garbas/vim-snipmate'
"Plugin 'SirVer/ultisnips'
Plugin '2072/PHP-Indenting-for-VIm'
Plugin 'StanAngeloff/php.vim'
Plugin 'captbaritone/better-indent-support-for-php-with-html'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'mhartington/oceanic-next'
Plugin 'jiangmiao/auto-pairs'

Plugin 'pangloss/vim-javascript'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required



" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

