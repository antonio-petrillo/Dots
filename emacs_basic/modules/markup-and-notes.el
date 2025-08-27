;; markup-and-notes.el --- Plain text is the best text -*- lexical-binding: t; -*-

(use-package darkroom
  :bind
  (("<leader> tw" . #'darkroom-tentative-mode)))

(use-package markdown-mode
  :config
  (setq markdown-fontify-code-blocks-natively t))

(use-package denote
  :hook
  ((text-mode . denote-fontify-links-mode-maybe)
   (dired-mode . denote-dired-mode)
   (markdown-mode . denote-dired-mode))
  :bind
  (("<leader> n n" . #'denote)
   ("<leader> n f" . #'denote-open-or-create)
   ("<leader> n N" . #'denote-type)
   ("<leader> n d" . #'denote-sort-dired)
   ("<leader> n i" . #'denote-link)
   ("<leader> n I" . #'denote-add-links)
   ("<leader> n b" . #'denote-backlinks)
   ("<leader> n r" . #'denote-rename-file-using-front-matter))
  :config
  (setq denote-directory (file-name-concat (getenv "HOME") "Documents" "Notes" "notes")
        denote-assets-directory (file-name-concat (getenv "HOME") "Documents" "Notes" "assets"))
  (setq denote-file-type 'markdown-yaml) ;; markdown is more *portable*
  (setq denote-infer-keywords t)
  (setq denote-sort-keywords t)
  (setq denote-buffer-name-prefix "[Note] ")
  (setq denote-rename-buffer-mode "%D")
  (denote-rename-buffer-mode 1))

;; I love org-mode but it bind to much stuff
(use-package org
  :ensure nil
  :bind
  (("<leader> oa" . #'org-agenda)
   :map org-mode-map
   ("C-'" . nil)
   ("C-," . nil)
   ("M-;" . nil)
   ("M-l" . nil)
   ("C-c ;" . nil))
  :config
  (setq org-agenda-span 'week
        org-agenda-start-on-weekday 1
        org-agenda-window-setup 'current-window)

  (setq org-M-RET-may-split-line '((default . nil))
        org-insert-heading-respect-content t
        org-log-done 'time
        org-log-into-drawer t
        org-ellipsis "⮧"
        org-adapt-indentation nil
        org-special-ctrl-a/e nil
        org-special-ctrl-k nil
        org-confirm-babel-evaluate nil
        org-src-window-setup 'current-window
        org-edit-src-persistent-message nil
        org-src-fontify-natively t
        org-src-preserve-indentation t
        org-src-tab-acts-natively t
        org-hide-emphasis-markers t
        org-edit-src-content-indentation 0
        org-export-with-toc t
        org-cycle-emulate-tab t
        org-export-headline-levels 8))

(provide 'markup-and-notes)
;; `markup-and-notes' ends here
