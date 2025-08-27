;; core.el --- Core config -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; Core configuration of my emacs, should be loaded before anything else.
;; When this is loaded all the other packages can be loaded in any order (ideally).
;;
;;; Code:



(add-to-list 'load-path (expand-file-name "modules/core" user-emacs-directory))

(require 'prefixes)

(require 'elpaca-setup)
(require 'builtins)
(require 'evil-setup)

(provide 'core)
;; `core' ends here
