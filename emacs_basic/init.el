;; init.el --- Description -*- lexical-binding: t; -*-

(add-to-list 'load-path (expand-file-name "modules" user-emacs-directory))

(require 'core)
(require 'ui)
(require 'completions)
(require 'movements)
(require 'text-goodies)
(require 'dired-setup)

(require 'docs)
(require 'markup-and-notes)
(require 'prog-setup)
