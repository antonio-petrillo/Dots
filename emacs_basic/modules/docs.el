;; docs.el --- Docs consulting utilities -*- lexical-binding: t; -*-

(use-package devdocs
  :custom
  (devdocs-data-dir (expand-file-name "devdocs" nto--cache))
  :bind
  (("<leader> hd" . #'devdocs-lookup)))

(provide 'docs)
;; `docs' ends here
