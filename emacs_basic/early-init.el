;;; early-init.el --- Early Init -*- lexical-binding: t; -*-

;;; Commentary:
;;
;;
;;; Code:

;; cache directory setup
(defvar nto--cache (file-name-concat (getenv "HOME") ".local/vanillaemacs"))

(unless (file-exists-p nto--cache)
  (make-directory nto--cache t))

;; don't pollute `user-emacs-directory'
(setq custom-file (file-name-concat nto--cache "custom.el")
      auto-save-list-file-prefix (file-name-concat nto--cache "auto-save-list/.saves-")
      package-user-dir (file-name-concat nto--cache "elpa")
      project-list-file (file-name-concat nto--cache "projects")
      bookmark-default-file (file-name-concat nto--cache "bookmarks")
      recentf-save-file (file-name-concat nto--cache "recentf")
      eshell-directory-name (file-name-concat nto--cache "eshell")
      treesit-extra-load-path (file-name-concat nto--cache "tree-sitter")
      transient-history-file (file-name-concat nto--cache "transient/history.el"))

;; setup other directories 
(setq org-directory (file-name-concat (getenv "HOME") "Documents" "Org"))

(startup-redirect-eln-cache (file-name-concat nto--cache "eln-cache"))

(load custom-file :no-error-if-file-is-missing)

(setq make-backup-files nil
      create-lockfiles nil
      inhibit-splash-screen t
      inhibit-startup-screen t
      ring-bell-function 'ignore
      use-short-answers 5
      inhibit-x-resources t
      inhibit-startup-buffer-menu t
      default-input-method "italian-postfix"
      package-enable-at-startup nil)

(setq-default truncate-lines t)

(add-to-list 'default-frame-alist
             '(menu-bar-lines . 0))
(add-to-list 'default-frame-alist
             '(tool-bar-lines . 0))
(add-to-list 'default-frame-alist
             '(vertical-scroll-bars . nil))

(when (native-comp-available-p)
  (setq native-comp-async-report-warnings-errors 'silent
        native-compile-prune-cache t))

(setq custom-safe-themes t)

(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)


(defvar nto/file-name-handler-alist file-name-handler-alist)
(defvar nto/vc-handled-backends vc-handled-backends)

(setq file-name-handler-alist nil
      vc-handled-backends nil)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024)
                  gc-cons-percentage 0.1
                  file-name-handler-alist nto/file-name-handler-alist
                  vc-handled-backends nto/vc-handled-backends)))

(provide 'early-init)
;;; early-init.el ends here
