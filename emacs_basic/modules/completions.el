;; completions.el --- Core config -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; Setup completions ui and helpers like:
;; - vertico
;; - marginalia
;; - corfu
;; - cape
;; - nerd-icons
;; - consult
;;
;;; Code:

(use-package consult
  :after evil
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :bind
  (([remap Info-search] . #'consult-info)
   ([remap switch-to-buffer] . #'consult-buffer)
   ([remap bookmark-jump] . #'consult-bookmark)
   ([remap load-theme] . #'consult-theme)
   ([remap project-switch-to-buffer] . #'consult-project-buffer)
   ([remap recentf-open-files] . #'consult-recent-file)
   ([remap yank-pop] . #'consult-yank-pop)
   ([remap imenu] . #'consult-imenu)
   ([remap locate] . #'consult-locate)
   ([remap goto-line] . #'consult-goto-line)

   ("M-y" . #'yank-pop)
   ("<leader> ht" . #'load-theme)
   ("<leader> hi" . #'consult-info)
   ("<leader> hm" . #'consult-man)

   ("<leader> ss" . #'consult-line)
   ("<leader> jc" . #'consult-line)
   ("<leader> jC" . #'goto-line)
   ("<leader> fg" . #'consult-ripgrep)
   ("<leader> /" . #'consult-ripgrep)
   ("<leader> ff" . #'consult-find)
   ("<leader> fl" . #'consult-locate)
   ("<leader> RET" . #'bookmark-jump)
   ("<leader> bb" . #'switch-to-buffer)

   :map minibuffer-local-map
   ("M-s" . #'consult-history)
   ("M-r" . #'consult-history)))

(use-package consult-dir
  :defer t
  :bind
  (([remap list-directory] . #'consult-dir)
   ("<leader> fd" . #'consult-dir)
   (:map vertico-map
         ("C-x C-d" . #'consult-dir)
         ("C-x C-j" . #'consult-dir-jump-file))))

(use-package vertico
  :hook (elpaca-after-init . vertico-mode)
  :config
  (setq vertico-scrool-margin 0
	vertico-count 10
	vertico-resize t
	vertico-cycle t)
  :bind
  (:map vertico-map
	("DEL" . #'vertico-directory-delete-char)
	("C-DEL" . #'vertico-directory-delete-word)))

(use-package vertico-mouse
  :ensure nil
  :if (not (display-graphic-p))
  :after vertico
  :hook (vertico-mode . vertico-mouse-mode))

(use-package orderless
  :config
  (setq completion-styles '(orderless basic))
  (setq completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :hook (elpaca-after-init . vertico-mode)
  :bind
  (:map minibuffer-local-map
	("M-A" . #'marginalia-cycle)))

(use-package corfu
  :bind
  (:map corfu-map
        ("<tab>" . #'corfu-complete)
        ("C-n" . #'corfu-next)
        ("C-p" . #'corfu-previous)
        ("RET" . #'corfu-insert)
        ("C-q" . #'corfu-quick-complete))
  :init
  (global-corfu-mode)
  :config
  (setq corfu-cycle t
        corfu-auto t
        corfu-quit-no-match t
        corfu-cycle-preview-current nil
        corfu-min-width 20
        corfu-popupinfo-delay '(1.00 . 0.5))

  (corfu-popupinfo-mode 1)

  (corfu-history-mode 1)

  (with-eval-after-load 'savehist
    (corfu-history-mode 1)
    (add-to-list 'savehist-additional-variables 'corfu-history))

  (add-hook 'corfu-mode-hook (lambda ()
                               (setq-local completion-sytle '(orderless basic)
                                           completion-category-overrides nil
                                           completion-category-defaults nil))))

(use-package corfu-terminal
  :ensure (:repo "https://codeberg.org/akib/emacs-corfu-terminal.git")
  :when (not (display-graphic-p))
  :hook (corfu-mode . corfu-terminal-mode))

(use-package cape
  :bind ("C-c p" . cape-prefix-map)
  :init
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-dict))

(use-package nerd-icons)

(use-package nerd-icons-completion
  :after marginalia
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package nerd-icons-corfu
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package nerd-icons-dired
  :hook
  (dired-mode . nerd-icons-dired-mode))

(use-package better-jumper
  :after evil
  :hook (evil-mode . better-jumper-mode)
  :init
  (global-set-key [remap evil-jump-forward]  #'better-jumper-jump-forward)
  (global-set-key [remap evil-jump-backward] #'better-jumper-jump-backward)
  (global-set-key [remap xref-pop-marker-stack] #'better-jumper-jump-backward)
  (global-set-key [remap xref-go-back] #'better-jumper-jump-backward)
  (global-set-key [remap xref-go-forward] #'better-jumper-jump-forward))

(provide 'completions)
;; `completions' ends here
