{ config, lib, pkgs, ... }:

{

  home.packages = with pkgs; [
    git
    emacs    
    emacsPackages.vterm
    emacsPackages.python
    emacsPackages.emacsql
    emacsPackages.pdf-tools


    ripgrep
    coreutils 
    fd
    jq
    clang
    cmake
    gnumake
    rtags
    nixfmt
    python314
    python314Packages.pytest
    ccls
    clang-tools
    libvterm

    sqlite
    graphviz

    nodejs
    glslang
    editorconfig-core-c
    html-tidy
    shellcheck
    nodePackages_latest.js-beautify
    rustc
    pipenv
    discount
    haskell-language-server
    haskellPackages.hoogle
    cabal-install
    php83Packages.composer
    php83
    phpactor
    cargo
    gopls
    gomodifytags
    gotests
    gore
    gotools
    isort
    stylelint
    ansible
    #nerd-fonts
  ];
}
