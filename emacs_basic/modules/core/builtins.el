;; builtins.el --- Builtin module -*- lexical-binding: t; -*-
;;; Commentary:
;;
;; Configure the builtin aspect of emacs, such as:
;; - variables
;; - enabling functionalities
;; - configure some keybindings for builtin cmds
;; - create custom functions
;;
;;; Code:

(defun nto--backward-kill-word()
  "Same as `backward-kill-word' but if it is invoked on a white space character
at the beginning of the line it will stop at it, furthermore if it is invoked
on the beginning of the line it will go the end of the previous line instead
of delete the previous word."
  (interactive)
  (let ((same? (save-excursion
                 (let ((orig (line-number-at-pos (point)))
                       (dest (progn
                               (backward-word)
                               (line-number-at-pos (point)))))
                   (eq orig dest))))
        (start? (eq (point) (line-beginning-position))))
    (cond (start? (backward-delete-char 1))
          (same? (backward-kill-word 1))
          (:else (kill-line 0)))))

(defun nto--keyboard-quit-dwim()
  "Do-What-I-Mean behaviour for a general `keyboard-quit'.

The generic `keyboard-quit' does not do the expected thing when
the minibuffer is open.  Whereas we want it to close the
minibuffer, even without explicitly focusing it.

The DWIM behaviour of this command is as follows:

- When the region is active, disable it.
- If the evil state is not normal then set to normal
- When a minibuffer is open, but not focused, close the minibuffer.
- When the Completions buffer is selected, close it.
- In every other case use the regular `keyboard-quit'."
  (interactive)
  (cond
   ((region-active-p)
    (keyboard-quit))
   ((not (= 'normal evil-state)) (evil-normal-state))
   ((derived-mode-p 'completion-list-mode)
    (delete-completion-window))
   ((> (minibuffer-depth) 0)
    (abort-recursive-edit))
   (t
    (keyboard-quit))))

;; For some reasong the 'C-DEL' on the terminal version is treated as 'C-h',
;; I can still access the 'C-DEL' call with 'M-DEL' but I prefer to have the same bindings.
;; The commands behinds 'C-h' can still be access through the '<leader>' key, more on the 'evil' module

(use-package emacs
  :ensure nil
  :after evil
  :custom
  (auto-save-default nil)
  (hscroll-margin 2)
  (tab-always-ident 'complete)
  (hscroll-step 1)
  (scroll-conservatively 10)
  (scroll-margin 0)
  (scroll-preserve-screen-position t)
  (auto-window-vscroll nil)
  (mouse-wheel-scroll-amount '(2 ((shift) . hscroll))
                             (mouse-wheel-scroll-amount-horizontal 2))
  :init
  (setq-default indent-tabs-mode nil
                tab-width 4)

  (setq completions-highlight-face nil)

  (global-set-key [remap backward-kill-word] #'nto--backward-kill-word)
  (global-set-key [remap keyboard-quit] #'nto--keyboard-quit-dwim)

  (global-set-key (kbd "C-h") #'nto--backward-kill-word)
  (global-unset-key (kbd "C-z"))

  (add-hook 'prog-mode-hook (lambda ()
                              (display-line-numbers-mode 1)
                              (hs-minor-mode)
                              (setq-local display-line-numbers 'relative)))

  (load-theme 'modus-vivendi)
  (recentf-mode)
  :bind
  ("<leader> tt" . #'toggle-truncate-lines)
  ("<leader> ie" . #'emoji-list)
  ("<leader> ii" . #'emoji-insert)
  ("<leader> id" . #'emoji-describe)
  ("<leader> is" . #'emoji-search)
  ("<leader> ir" . #'emoji-recent)
  ("<leader> iu" . #'insert-char)

  (:map emacs-lisp-mode-map
        ("<localleader> e" . #'eval-defun)
        ("<localleader> b" . #'eval-buffer)
        ("<localleader> r" . #'eval-region)))

(use-package savehist
  :ensure nil
  :hook (elpaca-after-init . savehist-mode)
  :config
  (setq savehist-file (expand-file-name "savehist" nto--cache)
        history-length 100
        history-delete-duplicates t
        savehist-save-minibuffer-history t)
  (add-to-list 'savehist-additional-variables 'kill-ring))

(use-package winner
  :ensure nil
  :hook (elpaca-after-init . winner-mode)
  :bind
  (("<leader> wu" . #'winner-undo)
   ("<leader> wr" . #'winner-redo)))

(use-package delsel
  :ensure nil
  :hook (elpaca-after-init . delete-selection-mode))
                        
(use-package electric
  :ensure nil
  :hook (prog-mode . electric-indent-local-mode)
  :config
  (setq electric-pair-pairs '((?\{ . ?\})
                              (?\[ . ?\])
                              (?\( . ?\))
                              (?\" . ?\"))))

(use-package tab-bar
  :ensure nil
  :after better-jumper
  :bind 
  (("C-<tab>" . #'tab-next)
   ("C-<backtab>" . #'tab-previous)
   ("<leader> <tab>s" . #'tab-switch)
   ("<leader> <tab><tab>" . #'tab-switch)
   ("<leader> <tab>c" . #'tab-close)
   ("<leader> <tab>n" . #'tab-new)
   ("<leader> <tab>r" . #'tab-rename)
   ("<leader> <tab>b" . #'switch-to-buffer-other-tab)
   ("<leader> <tab>d" . #'dired-other-tab)

   ("<leader> C-n" . #'tab-next)
   ("<leader> C-p" . #'tab-previous)

   ("C-TAB" . #'tab-next)
   ("C-S-TAB" . #'tab-previous)

   ("<leader> TAB s" . #'tab-switch)
   ("<leader> TAB TAB" . #'tab-switch)
   ("<leader> TAB c" . #'tab-close)
   ("<leader> TAB n" . #'tab-new)
   ("<leader> TAB r" . #'tab-rename)
   ("<leader> TAB b" . #'switch-to-buffer-other-tab)
   ("<leader> TAB d" . #'dired-other-tab)))

(use-package project
  :ensure nil
  :bind-keymap
  ("C-x p" . project-prefix-map)
  :bind
  (("<leader> pp" . #'project-switch-project)
   ("<leader> pb" . #'project-switch-to-buffer)
   ("<leader> pc" . #'project-compile)
   ("<leader> ps" . #'project-shell)
   ("<leader> pe" . #'project-eshell)
   ("<leader> pf" . #'project-find-file)
   ("<leader> pk" . #'project-kill-buffers)
   ("<leader> p&" . #'project-async-shell-command)))

  
(use-package which-key
  :ensure nil
  :hook (after-init . which-key-mode)
  :config
  (setq which-key-separator "  "
        which-key-prefix-prefix "... "
        which-key-max-display-columns 2
        which-key-idle-delay 1.0
        which-key-idle-secondary-delay 0.25
        which-key-add-column-padding 1
        which-key-max-description-length 45))

(provide 'builtins)
;; `builtins' ends here.
