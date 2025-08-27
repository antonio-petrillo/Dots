;; prog-setup.el --- Programming languages stuff -*- lexical-binding: t; -*-
(use-package eat
  :ensure (:host codeberg :repo "akib/emacs-eat")
  :init
  (add-hook 'eshell-load-hook #'eat-eshell-visual-command-mode)
  :bind
  (("<leader> ot" . #'eat)))

;; Put this on .bashrc to make eat work
;; [ -n "$EAT_SHELL_INTEGRATION_DIR" ] && \
;;   source "$EAT_SHELL_INTEGRATION_DIR/bash"

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

(provide 'prog-setup)
;; `prog-setup' ends here
