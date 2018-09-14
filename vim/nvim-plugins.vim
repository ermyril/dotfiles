"/
"/ Autocompletion and nvim-specific plugins
"/

"Plugin 'Valloric/YouCompleteMe'
Plug 'ncm2/ncm2', Cond(has('nvim'))
Plug 'roxma/nvim-yarp', Cond(has('nvim'))

" LanguageServer client for NeoVim. 
" I'm not quite sure that this will work with vundle
" so probably you should run install.sh manually
Plug 'autozimu/LanguageClient-neovim',Cond(has('nvim'), {
 \ 'branch': 'next',
 \ 'do': 'bash install.sh',
 \ })


"completion-sources - full list is available here https://github.com/ncm2/ncm2/wiki
Plug 'ncm2/ncm2-bufword',Cond(has('nvim'))

Plug 'ncm2/ncm2-tmux',Cond(has('nvim'))

Plug 'ncm2/ncm2-path',Cond(has('nvim'))

Plug 'ncm2/ncm2-cssomni',Cond(has('nvim'))

Plug 'ncm2/ncm2-tern', Cond(has('nvim'), {'do': 'npm install'})

Plug 'phpactor/phpactor', Cond(has('nvim'), {'do': 'composer install', 'for': 'php'})
