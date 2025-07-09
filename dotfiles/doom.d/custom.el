;;; custom.el -*- lexical-binding: t; -*-

(defhydra doom-window-resize-hydra (:hint nil)
  " Resize window with hjkl"
  ("h" evil-window-decrease-width)
  ("j" evil-window-increase-height)
  ("k" evil-window-decrease-height)
  ("l" evil-window-increase-width)
  ("q" nil))


(map! :leader
      :desc "Hydra resize"
      "w SPC" #'doom-window-resize-hydra/body)

(map! :leader
      :desc "Open private config"
      "f p" #'(lambda () (interactive) (projectile-find-file-in-directory "~/.dotfiles/.doom.d/")))

(map! :leader
      :desc "Open home-manager config"
      "f h" #'(lambda () (interactive) (projectile-find-file-in-directory "~/.dotfiles/.config/home-manager")))

(map! :leader "." nil)



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq doom-user-dir "~/.dotfiles/.doom.d")
