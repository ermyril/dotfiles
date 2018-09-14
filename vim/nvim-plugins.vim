"/
"/ Autocompletion and nvim-specific plugins
"/

"Phpactor for php completion
"
Plug 'phpactor/phpactor', Cond(has('nvim'), {'do': 'composer install', 'for': 'php'})

" LanguageServer client for NeoVim. 
" I'm not quite sure that this will work with vundle
" so probably you should run install.sh manually
"Plug 'autozimu/LanguageClient-neovim',Cond(has('nvim'), {
" \ 'branch': 'next',
" \ 'do': 'bash install.sh',
" \ })




Plug 'ncm2/ncm2', Cond(has('nvim')) " completion engine for nvim
Plug 'roxma/nvim-yarp', Cond(has('nvim')) 

Plug 'phpactor/ncm2-phpactor', Cond(has('nvim')) " Phpactor adapter for ncm2

Plug 'ncm2/ncm2-ultisnips', Cond(has('nvim'))

" /
" / completion-sources - full list is available here https://github.com/ncm2/ncm2/wiki
" /
"
Plug 'ncm2/ncm2-bufword',Cond(has('nvim'))

Plug 'ncm2/ncm2-tmux',Cond(has('nvim'))

Plug 'ncm2/ncm2-path',Cond(has('nvim'))

Plug 'ncm2/ncm2-cssomni',Cond(has('nvim'))

Plug 'ncm2/ncm2-tern', Cond(has('nvim'), {'do': 'npm install'})

Plug 'ncm2/ncm2-vim', Cond(has('nvim'))



