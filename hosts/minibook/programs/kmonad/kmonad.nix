{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      #./nixos-module.nix
    ];

    environment.etc."libinput/local-overrides.quirks".text = ''
        [Serial Keyboards]
        MatchUdevType=keyboard
        MatchName=KMonad output
        AttrKeyboardIntegration=internal
      '';


     services.kmonad = {
       enable = true;
       #package = pkgs.haskellPackages.kmonad;
       keyboards = {
          builtin = {
            device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
            config = ''
              (defcfg
                input  (device-file "/dev/input/by-path/platform-i8042-serio-0-event-kbd")
                output (uinput-sink "KMonad output")
                fallthrough true)

                  (defsrc
                    esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12  del
                    grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
                    tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
                    caps a    s    d    f    g    h    j    k    l    ;    '    ret
                    lsft z    x    c    v    b    n    m    ,    .    /    rsft       up
                    lctl lmet lalt           spc            ralt rctl       left down right
                  )

                  (defalias
                    nav (layer-toggle navigation)
                    tm (tap-next-press esc @nav)
                    off (layer-switch empty)
                    on (layer-switch base)
                  )


                  (deflayer base
                    _    _    _    _    _    _    _    _    _    _    _    _    _    _
                    _    _    _    _    _    _    _    _    _    _    _    _    _    _
                    _    _    _    _    _    _    _    _    _    _    _    _    _    _
                   @tm   _    _    _    _    _    _    _    _    _    _    _    _
                    _    _    _    _    _    _    _    _    _    _    _    _       _
                    _  lalt  lmet            _              _    _              _  _  _
                  )

                  (deflayer navigation
                    _   @off  _    _    _    _    _    _    _    _    _    _    _    _
                    _    _    _    _    _    _    _    _    _    _    _    _    _    _
                    _    _    _    _    _    _    _    _    _    _    _    _    _    _
                    _    _    _    _    _    _  left  down up  right  _    _    _
                    _    _    _    _    _    _    _    _    _    _    _    _       _
                    _    _    _              _              _    _              _  _  _
                  )

                  (deflayer empty
                    XX   @on    XX    XX    XX    XX    XX    XX    XX    XX    XX    XX    XX    XX
                    XX    XX    XX    XX    XX    XX    XX    XX    XX    XX    XX    XX    XX    XX
                    XX    XX    XX    XX    XX    XX    XX    XX    XX    XX    XX    XX    XX    XX
                    XX    XX    XX    XX    XX    XX    XX    XX    XX    XX    XX    XX    XX
                    XX    XX    XX    XX    XX    XX    XX    XX    XX    XX    XX    XX       XX
                    XX    XX    XX              XX              XX    XX              XX  XX  XX
                  )


              '';
          };
       };
    };
}
