;;; early-init.el --- Description -*- lexical-binding: t; -*-

(defvar nto--cache (file-name-concat (getenv "HOME") ".local/minimal-emacs"))

(unless (file-exists-p nto--cache)
  (make-directory nto--cache t))

(startup-redirect-eln-cache (expand-file-name "eln" nto--cache))
(setq package-user-dir (expand-file-name "elpa" nto--cache))

(setq no-littering-etc-directory (expand-file-name "etc" nto--cache))
(setq no-littering-var-directory (expand-file-name "var" nto--cache))

(setq custom-file (file-name-concat nto--cache "custom.el"))
(load custom-file :no-error-if-file-is-missing)

(setq make-backup-files nil)
(setq create-lockfiles nil)
(setq tramp-auto-save-directory (expand-file-name "tramp-autosave" nto--cache))

(setq org-persist-directory (expand-file-name "org/persist/" nto--cache)
      org-publish-timestamp-directory (expand-file-name "org/timestamps/" nto--cache)
      org-preview-latex-image-directory (expand-file-name "org/latex/" nto--cache)
      org-list-allow-alphabetical t)

(setq package-enable-at-startup nil)
(setq evil-want-keybinding nil)
(setq use-short-answers t)
(setq ring-bell-function 'ignore)

(setq inhibit-splash-screen t)
(setq-default truncate-lines t)
(setq inhibit-startup-screen t)

(add-to-list 'default-frame-alist
             '(menu-bar-lines . 0))
(add-to-list 'default-frame-alist
             '(tool-bar-lines . 0))
(add-to-list 'default-frame-alist
             '(vertical-scroll-bars . nil))

(setq menu-bar-mode nil
      tool-bar-mode nil
      scroll-bar-mode nil)

(add-to-list 'default-frame-alist '(fullscreen . maximized))

(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.5)

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
