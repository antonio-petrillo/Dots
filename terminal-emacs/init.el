;;; init.el --- Description -*- lexical-binding: t; -*-
(use-package undo-tree
  :ensure t
  :custom
  (undo-tree-history-directory-alist `(("." . ,(expand-file-name "undo-tree-hist/" nto--cache))))
  :init
  (global-undo-tree-mode))

(use-package evil
  :ensure t
  :after undo-tree
  :hook (after-init . evil-mode)
  :custom
  (evil-undo-system 'undo-tree)
  :config
  (setq evil-want-C-i-jump nil)
  (setq evil-want-C-u-delete nil)
  (setq evil-want-C-u-scroll nil)
  (setq evil-want-C-d-scroll nil)
  (setq evil-want-Y-yank-to-eol t)
  (setq evil-disable-insert-state-bindings t)
  (setq evil-split-window-below t)
  (setq evil-split-window-right t)
  (setq evil-want-fine-undo t))
