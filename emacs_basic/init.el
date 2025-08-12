;; init.el --- Description -*- lexical-binding: t; -*-

(when (native-comp-available-p)
  (setq native-comp-async-report-warnings-errors 'silent
        native-compile-prune-cache t))

(setq custom-safe-themes t)
(defvar elpaca-installer-version 0.11)
(defvar elpaca-directory (expand-file-name "elpaca/" nto--cache))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                       :ref nil :depth 1 :inherit ignore
                       :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                       :build (:not elpaca--activate-package)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (<= emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                  ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                  ,@(when-let* ((depth (plist-get order :depth)))
                                                      (list (format "--depth=%d" depth) "--no-single-branch"))
                                                  ,(plist-get order :repo) ,repo))))
                  ((zerop (call-process "git" nil buffer t "checkout"
                                        (or (plist-get order :ref) "--"))))
                  (emacs (concat invocation-directory invocation-name))
                  ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                        "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                  ((require 'elpaca))
                  ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (let ((load-source-file-function nil)) (load "./elpaca-autoloads"))))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

(elpaca elpaca-use-package
        (elpaca-use-package-mode))

(setq use-package-always-ensure t)

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

  (define-key global-map [remap backward-kill-word] #'nto--backward-kill-word)
  (define-key global-map [remap keyboard-quit] #'nto--keyboard-quit-dwim)

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

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package evil
  :hook (elpaca-after-init . evil-mode)
  :custom
  (evil-disable-insert-state-bindings t)
  :config
  (setq evil-undo-system 'undo-redo
        evil-want-C-i-jump t
        evil-want-C-u-scroll t
        evil-want-C-d-scroll t
        evil-want-Y-yank-to-eol t
        evil-split-window-below t
        evil-split-window-right t
        evil-want-fine-undo t)

  (evil-set-leader nil (kbd "M-SPC"))
  (evil-set-leader 'normal (kbd "SPC"))

  (evil-set-leader nil (kbd "<leader> m") t)
  (evil-set-leader 'normal (kbd "<leader> m") t)

  (evil-define-key 'normal dired-mode-map
    (kbd "h") #'dired-up-directory
    (kbd "l") #'dired-find-file)

  (evil-define-key '(normal visual operator replace motion) 'global
    (kbd "gr") #'revert-buffer)

  (define-key evil-insert-state-map (kbd "C-n") nil)
  (define-key evil-insert-state-map (kbd "C-p") nil)
  (define-key evil-insert-state-map (kbd "C-q") nil)

   (evil-define-key '(insert normal) 'global
    (kbd "C-a") #'beginning-of-line
    (kbd "C-e") #'end-of-line
    (kbd "C-f") #'forward-char
    (kbd "C-b") #'backward-char
    (kbd "C-p") #'previous-line
    (kbd "C-n") #'next-line)

  (evil-define-key nil 'global
    (kbd "<leader> hk") #'describe-key
    (kbd "<leader> hv") #'describe-variable
    (kbd "<leader> hf") #'describe-function
    (kbd "<leader> hc") #'describe-command
    (kbd "<leader> hK") #'describe-keymap

    (kbd "<leader> .") #'find-file
    (kbd "<leader> fs") #'save-buffer
    (kbd "<leader> fr") #'recentf-open-files

    (kbd "<leader> bk") #'kill-current-buffer
    (kbd "<leader> bK") #'kill-buffer
    (kbd "<leader> br") #'revert-buffer

    (kbd "<leader> bm") #'bookmark-set
    (kbd "<leader> bd") #'bookmark-delete

    (kbd "<leader> SPC") #'execute-extended-command
    (kbd "<leader> C-SPC") #'execute-extended-command-for-buffer

    (kbd "<leader> tl") #'display-line-numbers-mode

    (kbd "<leader> ws") #'evil-window-split
    (kbd "<leader> wv") #'evil-window-vsplit
    (kbd "<leader> wc") #'evil-window-delete
    (kbd "<leader> wM") #'toggle-frame-maximized
    (kbd "<leader> wh") #'evil-window-left
    (kbd "<leader> wj") #'evil-window-down
    (kbd "<leader> wk") #'evil-window-up
    (kbd "<leader> wl") #'evil-window-right
    (kbd "<leader> w1") #'delete-other-windows
    (kbd "<leader> wm") #'delete-other-windows
    (kbd "<leader> w0") #'delete-window
    (kbd "<leader> wo") #'other-window))

(use-package evil-terminal-cursor-changer
  :if (not (display-graphic-p))
  :init
  (evil-terminal-cursor-changer-activate))

(use-package evil-escape
  :after evil
  :init
  (evil-escape-mode)
  :config
  (setq-default evil-escape-key-sequence "jk"
		evil-escape-delay 0.2))

(use-package evil-exchange
  :after evil
  :commands evil-exchange
  :init
  (evil-exchange-install))

(use-package evil-lion
  :after evil
  :config
  (evil-lion-mode))

(use-package evil-surround
  :after evil
  :config
  (global-evil-surround-mode 1))

(use-package evil-snipe
  :after evil
  :commands evil-snipe-local-mode evil-snipe-override-local-mode
  :hook ((evil-mode . evil-snipe-override-mode)
	     (evil-mode . evil-snipe-mode))
  :init
  (evil-define-key 'motion evil-snipe-override-local-mode-map
    "t" nil
    "T" nil)

  (setq evil-snipe-smart-case t
	evil-snipe-scope 'line
	evil-snipe-repeat-scope 'visible
	evil-snipe-char-fold t))

(use-package evil-visualstar
  :after evil
  :hook (evil-mode . global-evil-visualstar-mode)
  :config
  (setq-default evil-visualstar/persistent t))

(use-package exato
  :after evil)

(use-package evil-nerd-commenter
  :after evil
  :init
  (evil-define-key '(visual normal) 'global "gc" #'evilnc-comment-operator))

(use-package evil-multiedit
  :after evil
  :config
  (evil-define-key 'normal 'global
    (kbd "M-a")   #'evil-multiedit-match-symbol-and-next
    (kbd "M-A")   #'evil-multiedit-match-symbol-and-prev)
  (evil-define-key 'visual 'global
    "R"           #'evil-multiedit-match-all
    (kbd "M-a")   #'evil-multiedit-match-and-next
    (kbd "M-A")   #'evil-multiedit-match-and-prev)
  (evil-define-key '(visual normal) 'global
    (kbd "C-M-a") #'evil-multiedit-restore)

  (with-eval-after-load 'evil-mutliedit
    (evil-define-key 'multiedit 'global
      (kbd "M-a")   #'evil-multiedit-match-and-next
      (kbd "M-S-a") #'evil-multiedit-match-and-prev
      (kbd "RET")   #'evil-multiedit-toggle-or-restrict-region)
    (evil-define-key '(multiedit multiedit-insert) 'global
      (kbd "C-n")   #'evil-multiedit-next
      (kbd "C-p")   #'evil-multiedit-prev))

  (evil-ex-define-cmd "ie[dit]" 'evil-multiedit-ex-match))

(use-package evil-goggles
  :config
  (evil-goggles-mode)
  (evil-goggles-use-diff-faces))

(use-package evil-traces
  :config
  (evil-traces-use-diff-faces)
  (evil-traces-mode))

(use-package savehist
  :ensure nil
  :hook (elpaca-after-init . savehist-mode)
  :config
  (setq savehist-file (expand-file-name "savehist" nto--cache)
        history-length 100
        history-delete-duplicates t
        savehist-save-minibuffer-history t)
  (add-to-list 'savehist-additional-variables 'kill-ring))

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

(use-package rotate-text
  :ensure (:host github :repo "debug-ito/rotate-text.el")
  :after evil
  :config
  (evil-define-key 'normal 'global
    (kbd "]r") #'rotate-text
    (kbd "[r") #'rotate-text-backward))

(with-eval-after-load 'rotate-text
  (dolist (rotate-words '(("false" "true")
                          ("nord" "east" "sud" "ovest")
                          ("up" "down" "left" "right")
                          ("top" "bottom")))
    (cl-pushnew rotate-words rotate-text-words))
  (dolist (rotate-symbols '(("var" "const")
                            ("and" "or")
                            ("&&" "||")))
    (cl-pushnew rotate-symbols rotate-text-symbols)))

(use-package avy
  :after evil
  :config
  (setq avy-all-windows nil)
  :bind
  (("<leader> jj" . #'avy-goto-char-timer)
   ("<leader> jl" . #'avy-goto-line)
   ("<leader> je" . #'avy-goto-end-of-line)
   ("<leader> jw" . #'avy-goto-word-0)))
   
(use-package ace-window
  :after evil
  :bind
  (("<leader> ww" . #'ace-window)
   ("<leader> wS" . #'ace-swap-window)
   ("<leader> w C-w" . #'ace-swap-window)
   ("<leader> wx" . #'ace-delete-window))
  :config
  (setq aw-background nil)
  (setq aw-dispatch-always t)
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
  (defvar aw-dispatch-alist
    '((?x aw-delete-window "Delete Window")
      (?m aw-swap-window "Swap Windows")
      (?M aw-move-window "Move Window")
      (?c aw-copy-window "Copy Window")
      (?j aw-switch-buffer-in-window "Select Buffer")
      (?n aw-flip-window)
      (?u aw-switch-buffer-other-window "Switch Buffer Other Window")
      (?c aw-split-window-fair "Split Fair Window")
      (?v aw-split-window-vert "Split Vert Window")
      (?b aw-split-window-horz "Split Horz Window")
      (?o delete-other-windows "Delete Other Windows")
      (?? aw-show-dispatch-help))
    "List of actions for `aw-dispatch-default'."))

(use-package winner
  :ensure nil
  :hook (elpaca-after-init . winner-mode)
  :bind
  (("<leader> wu" . #'winner-undo)
   ("<leader> wr" . #'winner-redo)))

(use-package dired
  :ensure nil
  :after evil
  :commands (dired)
  :custom
  (dired-listing-switches "-aghl -v --group-directories-first")
  :config
  (setq dired-recursive-copies 'always
        dired-recursive-deletes 'always
        delete-by-moving-to-trash t
        dired-mouse-drag-fiels t
        dired-make-directory-clickable t
        dired-dwim-target t)

  (evil-define-key 'normal dired-mode-map
    (kbd "h") #'dired-up-directory
    (kbd "l") #'dired-find-file
    (kbd "SPC") nil))

(use-package dired-subtree
  :after dired
  :bind
  (:map dired-mode-map
        ("<tab>" . #'dired-subtree-toggle)
        ("TAB" . #'dired-subtree-toggle)
        ("<backtab>" . #'dired-subtree-remove)
        ("S-TAB" . #'dired-subtree-remove))
  :config
  (setq dired-subtree-use-backgrounds nil))

(use-package trashed
  :commands (trashed)
  :bind ("<leader> C-," . #'trashed)
  :config
  (setq trashed-action-confirmer 'y-or-n-p
        trashed-use-header-line t
        trashed-sort-key '("Date deleted: " . t)
        trashed-date-format "%d-%m-%Y %H:%M:%S"))

(use-package delsel
  :ensure nil
  :hook (elpaca-after-init . delete-selection-mode))

(use-package electric
  :ensure nil
  :hook
  (prog-mode . electric-indent-local-mode))

(use-package better-jumper
  :after evil
  :hook (evil-mode . better-jumper-mode)
  :init
  (global-set-key [remap evil-jump-forward]  #'better-jumper-jump-forward)
  (global-set-key [remap evil-jump-backward] #'better-jumper-jump-backward)
  (global-set-key [remap xref-pop-marker-stack] #'better-jumper-jump-backward)
  (global-set-key [remap xref-go-back] #'better-jumper-jump-backward)
  (global-set-key [remap xref-go-forward] #'better-jumper-jump-forward))

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

(use-package jinx
  :hook ((org-mode . jinx-mode)
         (markdown-mode . jinx-mode)
         (text-mode . jinx-mode))
  :bind
  (([remap ispell-word] . #'jinx-correct)
   ("<leader> lc" . #'jinx-correct)
   ("<leader> ll" . #'jinx-languages)
   ("<leader> ln" . #'jinx-next)
   ("<leader> lp" . #'jinx-previous))
  :config
  (setq jinx-languages "en_US, it_IT"))
                        
(use-package electric
  :ensure nil
  :hook (prog-mode . electric-pair-mode)
  :config
  (setq electric-pair-pairs '((?\{ . ?\})
                              (?\[ . ?\])
                              (?\( . ?\))
                              (?\" . ?\"))))

(use-package tempel
  :bind
  (("M-=" . #'tempel-insert))
  :custom
  (tempel-trigger-prefix "<")
  :init
  (defun tempel-setup-capf ()
    (setq-local completion-at-point-functions
                (cons #'tempel-complete completion-at-point-functions)))

  (add-hook 'prog-mode-hook 'tempel-setup-capf)
  (add-hook 'conf-mode-hook 'tempel-setup-capf)
  (add-hook 'text-mode-hook 'tempel-setup-capf))

(use-package markdown-mode)

(use-package denote
  :after markdown
  :hook
  ((text-mode . denote-fontify-links-mode-maybe)
   (dired-mode . denote-dired-mode)
   (markdown-mode . denote-dired-mode))
  :bind
  (("<leader> n n" . #'denote)
   ("<leader> n f" . #'denote-open-or-create)
   ("<leader> n N" . #'denote-type)
   ("<leader> n d" . #'denote-sort-dired)
   :map text-mode-map
   ("<leader> n i" . #'denote-link)
   ("<leader> n I" . #'denote-add-links)
   ("<leader> n b" . #'denote-backlinks)
   ("<leader> n r" . #'denote-rename-file-using-front-matter)
   :map markdown-mode-map
   ("<leader> n i" . #'denote-link)
   ("<leader> n I" . #'denote-add-links)
   ("<leader> n b" . #'denote-backlinks)
   ("<leader> n r" . #'denote-rename-file-using-front-matter)
   :map org-mode-map
   ("<leader> n i" . #'denote-link)
   ("<leader> n I" . #'denote-add-links)
   ("<leader> n b" . #'denote-backlinks)
   ("<leader> n r" . #'denote-rename-file-using-front-matter))
  :config
  (setq denote-directory (file-name-concat (getenv "HOME") "Documents" "Notes" "notes"))
  (setq denote-file-type 'markdown-toml)
  (setq denote-infer-keywords t)
  (setq denote-sort-keywords t)
  (setq denote-buffer-name-prefix "[Note] ")
  (setq denote-rename-buffer-mode "%D")
  (denote-rename-buffer-mode 1))

(use-package consult-denote
  :bind
  (("<leader> nF" . #'consult-denote-find)
   ("<leader> ng" . #'consult-denote-grep))
  :config
  (consult-denote-mode 1))

(use-package go-mode)

(use-package zig-mode
  :config
  (setq zig-format-on-save t)
  :bind
  (:map zig-mode-map
        ("<localleader> c" . #'zig-compile)
        ("<localleader> f" . #'zig-format-buffer)
        ("<localleader> r" . #'zig-run)
        ("<localleader> t" . #'zig-test-buffer)))

(use-package odin-mode
  :ensure (:host sourcehut :repo "mgmarlow/odin-mode")
  :bind
  (:map odin-mode-map
        ("<localleader> c" . #'odin-build-project)
        ("<localleader> C" . #'odin-check-project)
        ("<localleader> r" . #'odin-run-project)
        ("<localleader> t" . #'odin-test-project)))

(use-package elm-mode)

(use-package elixir-ts-mode)

(use-package elixir-mode
  :bind
  (:map elixir-mode-map
        ("<localleader> f" . #'elixir-format)))
