;; ui.el --- UI stuff goes here -*- lexical-binding: t; -*-

(let ((mono-spaced-font "Aporetic Serif Mono") ;; "Monospace" backup
      (proportionately-spaced-font "Aporetic Sans")) ;; "Sans" backup

  (set-face-attribute
   'default nil
   :family mono-spaced-font
   :height 120)

  (set-face-attribute
   'fixed-pitch nil
   :family mono-spaced-font
   :height 1.0)

  (set-face-attribute
   'variable-pitch nil
   :family proportionately-spaced-font
   :height 1.0))

(use-package doom-themes)
(use-package ef-themes)
(use-package tron-legacy-theme)
(use-package spacemacs-theme)
(use-package anti-zenburn-theme)
(use-package gruber-darker-theme)
(use-package naysayer-theme)

(provide 'ui)
;; `ui' ends here
