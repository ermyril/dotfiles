# dotfiles
## mostly obsolete due to moving to nix
![screenshot](https://i.redd.it/91sfmofjb6k31.jpg)

Terminal: [Kitty](https://github.com/kovidgoyal/kitty)  
Terminal multiplexer: [Tmux](https://github.com/tmux/tmux) with [Tmux themepack](https://github.com/jimeh/tmux-themepack)  
Terminal colorscheme: [Oceanic Next](https://github.com/denysdovhan/oceanic-next-gnome-terminal/blob/master/COLORS)  
Prompt: [Spaceship](https://github.com/denysdovhan/spaceship-prompt)  
ls with icons: [Color LS](https://github.com/athityakumar/colorls)  

WM: [BSPWM](https://github.com/baskerville/bspwm)  
Panel: [Polybar](https://github.com/polybar/polybar) with slightly customized theme from [polybar-themes](https://github.com/adi1090x/polybar-themes)  
Lockscreen: [Betterlockscreen](https://github.com/pavanjadhaw/betterlockscreen)  
Launcher: [rofi](https://github.com/davatorium/rofi)  

Activity monitor: [gotop](https://github.com/cjbassi/gotop)  
Good ol [bonsai.sh](https://gitlab.com/jallbrit/bonsai.sh/raw/master/bonsai.sh)  

Editor colorscheme: [Oceanic Next](https://github.com/denysdovhan/oceanic-next-gnome-terminal/blob/master/COLORS)  



###dependencies:
- [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
- [NVM](https://github.com/creationix/nvm#system-version-of-node)


- [tmux copypaste](https://subash.com.au/vim-style-copy-paste-in-tmux/)

Package-manager for zsh:
- https://zplug.sh


### VIM / NeoVim 
requires vim compiled with python support ( vim-nox )
neovim [setted up with python support](https://github.com/zchee/deoplete-jedi/wiki/Setting-up-Python-for-Neovim/)

nvim/init.vim should be linked with ~/.config/nvim/init.vim


nVim using [ncm2](https://github.com/ncm2/ncm2) for autocompletion, 



you should probably check [LanguageClient-neovim](https://github.com/autozimu/LanguageClient-neovim) with [corresponding language server](https://langserver.org/#implementations-server)
There is an [awesome tutorial](https://jacky.wtf/weblog/language-client-and-neovim/) for doing that.

[Composer](https://getcomposer.org/) is required for php-completion support

js completion using [ternjs](https://ternjs.net/doc/manual.html#configuration), so check it;
