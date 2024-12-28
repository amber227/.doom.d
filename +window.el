;;; +window.el -*- lexical-binding: t; -*-

(map!
 :map evil-window-map
 "." #'delete-other-windows
 "SPC" #'doom-window-resize-hydra/body)

(setq doom-window-resize-rate-coarse 5)
(setq doom-window-resize-rate-fine 1)

(defhydra doom-window-resize-hydra (:hint nil)
  "
               _k_ increase height
  _h_ decrease width    _l_ increase width ... SHIFT to fine tune
               _j_ decrease height
  "
  ("h" (lambda () (interactive) (evil-window-decrease-width doom-window-resize-rate-coarse)))
  ("j" (lambda () (interactive) (evil-window-decrease-height doom-window-resize-rate-coarse)))
  ("k" (lambda () (interactive) (evil-window-increase-height doom-window-resize-rate-coarse)))
  ("l" (lambda () (interactive) (evil-window-increase-width doom-window-resize-rate-coarse)))

  ("H" (lambda () (interactive) (evil-window-decrease-width doom-window-resize-rate-fine)))
  ("J" (lambda () (interactive) (evil-window-decrease-height doom-window-resize-rate-fine)))
  ("K" (lambda () (interactive) (evil-window-increase-height doom-window-resize-rate-fine)))
  ("L" (lambda () (interactive) (evil-window-increase-width doom-window-resize-rate-fine)))

  ("q" nil))
