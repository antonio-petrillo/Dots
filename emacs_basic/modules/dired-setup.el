;; dired-setup.el --- Best file manager out there -*- lexical-binding: t; -*-

(use-package dired
  :ensure nil
  :after evil
  :commands (dired)
  :custom
  (dired-listing-switches "-aghl -v --group-directories-first")
  :bind
  (:map dired-mode-map
        ("SPC" . nil)) ;; free up space for <leader>
  :config
  (setq dired-recursive-copies 'always
        dired-recursive-deletes 'always
        delete-by-moving-to-trash t
        dired-mouse-drag-fiels t
        dired-make-directory-clickable t
        dired-dwim-target t)

  (evil-define-key 'normal dired-mode-map
    (kbd "h") #'dired-up-directory
    (kbd "l") #'dired-find-file))

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

(provide 'dired-setup)
;; `dired-setup' ends here
