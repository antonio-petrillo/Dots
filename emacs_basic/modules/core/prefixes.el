;; prefixes.el --- prefixes and Keymaps module -*- lexical-binding: t; -*-
(defvar-keymap nto--prefix-buffer-and-bookmarks-map
  :doc "Prefix keymap for buffers and bookmarks."
  :name "Buffer"
  :prefix 'nto--prefix-buffer-and-bookmark
  ;; buffers commands
  "b" #'switch-to-buffer
  "k" #'kill-current-buffer
  "r" #'revert-buffer

  ;; bookmarks commands
  "m" #'bookmark-set
  "d" #'bookmark-delete)

(defvar-keymap nto--prefix-file-map
  :doc "Prefix keymap for files."
  :name "File"
  :prefix 'nto--prefix-file
  "s" #'save-buffer
  "f" #'find-file
  "r" #'recentf-open-files)

(defvar-keymap nto--prefix-help-map
  :doc "Prefix keymap for helps commands."
  :name "Help"
  :prefix 'nto--prefix-help
  "k" #'describe-key
  "K" #'describe-keymap
  "c" #'describe-command
  "f" #'describe-function
  "v" #'describe-variable)

(defvar-keymap nto--prefix-window-map
  :doc "Prefix keymap for window (not the os) commands."
  :name "Window"
  :prefix 'nto--prefix-window
  "m" #'toggle-frame-maximized
  "1" #'delete-other-windows
  "0" #'delete-window
  "o" #'other-window
  "2" #'split-window-below
  "3" #'split-window-right)

(defvar-keymap nto--prefix-toggle-map
  :doc "Prefix keymap for toggles"
  :name "Toggle"
  :prefix 'nto--prefix-toggle
  "l" #'display-line-numbers-mode)

(defvar-keymap nto--prefix-map
  :doc "Root keymap for all other keymap"
  :name "Root Keymap"
  :prefix 'nto--prefix
  "b" (cons "Buffer|Bookmark" 'nto--prefix-buffer-and-bookmark)
  "h" (cons "Help" 'nto--prefix-help)
  "f" (cons "File" 'nto--prefix-file)
  "t" (cons "Toggle" 'nto--prefix-toggle)
  "w" (cons "Window" 'nto--prefix-window)

  "." #'find-file
  "RET" #'bookmark-jump
  "SPC" #'execute-extended-command
  "M-SPC" #'execute-extended-command-for-buffer)

(global-set-key (kbd "C-c C-c") #'nto--prefix)

(provide 'prefixes)
;; `prefixes' ends here.
