;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!
;;


;; SWITCH THAT SO IT'S ENABLED ONLY ON LINUX

;; make the whole not IS-MAC work
;; (if (not IS-MAC 
;;(setq default-frame-alist '((undecorated . t)))
;;))

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Er Myril"
      user-mail-address "ermyril@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-henna)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Notes/")


;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;
;;
;; (after! tide
;;   (remove-hook! tide-mode 'tide-hl-identifier-mode))

(menu-bar-mode 0) ;; small menu-bar

(setq
 projectile-project-search-path '("~/Projects" "~/.dotfiles")
 )

<<<<<<< HEAD:home-manager/.doom.d/config.el

;; Together.ai offers an OpenAI compatible API
(gptel-make-openai "TogetherAI"         ;Any name you want
  :host "api.together.xyz"
  ;; :key "your-api-key"                   ;can be a function that returns the key
  :stream t
  :models '(;; has many more, check together.ai
            mistralai/Mixtral-8x7B-Instruct-v0.1
            codellama/CodeLlama-13b-Instruct-hf
            codellama/CodeLlama-34b-Instruct-hf))


;; (setq tidal-boot-script-path "~/.local/share/x86_64-osx-ghc-9.6.2/tidal-1.9.4/BootTidal.hs")

;; (use-package! org-roam
;;   :ensure t
;;   :custom
;;   (org-roam-directory (file-truename "~/Notes"))
;;   ;; (org-roam-dailies-directory "journals/")
;;   :config
;;   ;; If you're using a vertical completion framework, you might want a more informative completion interface
;;   (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
;;   (org-roam-db-autosync-mode)
;;   ;; If using org-roam-protocol
;; ;;   (require 'org-roam-protocol))

;;   (use-package! org-roam
;;      :after org
;;      :hook (org-mode . org-roam-mode)
;;      :custom
;;      (org-roam-directory "~/org-roam")
;;      :bind (:map org-roam-mode-map
;;                  (("C-c n l" . org-roam)
;;                   ("C-c n f" . org-roam-find-file)
;;                   ("C-c n g" . org-roam-graph))
;;                  :map org-mode-map
;;                  (("C-c n i" . org-roam-insert))
;;                  (("C-c n I" . org-roam-insert-immediate))))

;; (setq org-roam-file-exclude-regexp "\\.git/.*\\|logseq/.*$"
;;       org-roam-capture-templates
;;       '(("d" "default" plain
;;          "%?"
;;          ;; Accomodates for the fact that Logseq uses the "pages" directory
;;          :target (file+head "pages/${slug}.org" "#+title: ${title}\n")
;;          :unnarrowed t))
;;       org-roam-dailies-capture-templates
;;       '(("d" "default" entry
;;          "* %?"
;;          :target (file+head "%<%Y-%m-%d>.org" ;; format matches Logseq
;;                             "#+title: %<%Y-%m-%d>\n"))))
=======
;; accept completion from copilot and fallback to company
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word))
  )

(require 'lsp-mode)
(add-hook 'go-mode-hook #'lsp-deferred)


;; Set up before-save hooks to format buffer and add/delete imports.
;; Make sure you don't have other gofmt/goimports hooks enabled.
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)


;; Я ебал в рот gopls, лучше учиться кодить на лиспе
(after! go-mode
  (defun my-fix-pp-imports-after-organize ()
    "Replace occurrences of 'github.com/k0kubun/pp' with 'github.com/k0kubun/pp/v3'."
    (save-excursion
      (goto-char (point-min))
      (while (search-forward "github.com/k0kubun/pp\"" nil t)
        (replace-match "github.com/k0kubun/pp/v3\"" nil t))))
  (advice-add 'lsp-organize-imports :after #'my-fix-pp-imports-after-organize))
>>>>>>> origin/mac:.doom.d/config.el
