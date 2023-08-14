{ config, pkgs, ... }:

{
    imports = [
        ./dotfiles.nix
       ./tmux.nix
   ];
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "nikitami";
  home.homeDirectory = "/Users/nikitami";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Packages to install
  home.packages = [
    pkgs.tmux
    pkgs.go
    pkgs.vim
    pkgs.neofetch
    pkgs.ripgrep
    pkgs.git
    pkgs.coreutils
    pkgs.fd
    pkgs.gnupg
    pkgs.cmake
    pkgs.gnugrep
    pkgs.tree
    pkgs.nmap
    pkgs.bchunk
    pkgs.jq
    pkgs.htop
    pkgs.glances
    pkgs.pstree
    pkgs.picocom
    pkgs.parallel
    #pkgs.yabai # shit is not working due to plist fuckery in home-manager
    #pkgs.skhd # same as above
  ];

programs.fish.interactiveShellInit = ''
  set -g fish_greeting ""
  set -x PATH ~/.config/emacs/bin $PATH
  set -U fish_color_autosuggestion      brblack
  set -U fish_color_cancel              -r
  set -U fish_color_command             green
  set -U fish_color_comment             magenta
  set -U fish_color_cwd                 green
  set -U fish_color_cwd_root            red
  set -U fish_color_end                 magenta
  set -U fish_color_error               red
  set -U fish_color_escape              cyan
  set -U fish_color_history_current     --bold
  set -U fish_color_host                normal
  set -U fish_color_normal              normal
  set -U fish_color_operator            cyan
  set -U fish_color_param               blue
  set -U fish_color_quote               yellow
  set -U fish_color_redirection         yellow
  set -U fish_color_search_match        'yellow' '--background=brightblack'
  set -U fish_color_selection           'white' '--bold' '--background=brightblack'
  set -U fish_color_status              red
  set -U fish_color_user                green
  set -U fish_color_valid_path          --underline
  set -U fish_pager_color_completion    normal
  set -U fish_pager_color_description   yellow
  set -U fish_pager_color_prefix        'white' '--bold' '--underline'
  set -U fish_pager_color_progress      'white' '--background=cyan'
  # prompt
  set fish_prompt_pwd_dir_length 1
  set __fish_git_prompt_show_informative_status 1
  set fish_color_command green
  set fish_color_param $fish_color_normal
  set __fish_git_prompt_showdirtystate 'yes'
  set __fish_git_prompt_showupstream 'yes'
  set __fish_git_prompt_color_branch brown
  set __fish_git_prompt_color_dirtystate red
  set __fish_git_prompt_color_stagedstate yellow
  set __fish_git_prompt_color_upstream cyan
  set __fish_git_prompt_color_cleanstate green
  set __fish_git_prompt_color_invalidstate red
  set __fish_git_prompt_char_dirtystate ' ✕ '
  set __fish_git_prompt_char_stateseparator ' '
  set __fish_git_prompt_char_untrackedfiles '++'
  set __fish_git_prompt_char_cleanstate ' ✓ '
  set __fish_git_prompt_char_stagedstate '-> '
  set __fish_git_prompt_char_conflictedstate "✕ "
  set __fish_git_prompt_char_upstream_prefix ""
  set __fish_git_prompt_char_upstream_equal ""
  set __fish_git_prompt_char_upstream_ahead ' >= '
  set __fish_git_prompt_char_upstream_behind ' <= '
  set __fish_git_prompt_char_upstream_diverged ' <=> '
  function _print_in_color
    set -l string $argv[1]
    set -l color  $argv[2]
    set_color $color
    printf $string
    set_color normal
  end
  function _prompt_color_for_status
    if test $argv[1] -eq 0
      echo magenta
    else
      echo red
    end
  end
  function fish_prompt
      set -l last_status $status
      set -l nix_shell_info (
        if test -n "$IN_NIX_SHELL"
          echo -n " [nix-shell]"
        end
      )
      if test $HOME != $PWD
          _print_in_color ""(prompt_pwd) blue
      end
      __fish_git_prompt " (%s)"
      _print_in_color "$nix_shell_info λ " (_prompt_color_for_status $last_status) ]
  end

  fnm env --use-on-cd | source
'';

  #programs.tmux.enable = true;
  

  programs.fish.enable = true;
  programs.fish.plugins = [{
    name = "z";
    src = pkgs.fetchFromGitHub {
      owner = "jethrokuan";
      repo = "z";
      rev = "e0e1b9dfdba362f8ab1ae8c1afc7ccf62b89f7eb";
      sha256 = "0dbnir6jbwjpjalz14snzd3cgdysgcs3raznsijd6savad3qhijc";
    };
  }];
}
