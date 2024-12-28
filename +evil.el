;;; +evil.el -*- lexical-binding: t; -*-

(map! :map evil-outer-text-objects-map
  "b" #'evil-a-paren
  "B" #'evil-a-bracket
  "c" #'evil-a-curly
  "C" #'evilnc-outer-comment)

(map! :map evil-inner-text-objects-map
  "b" #'evil-inner-paren
  "B" #'evil-inner-bracket
  "c" #'evil-inner-curly
  "C" #'evilnc-inner-comment)

(map! :m
  "0" #'doom/backward-to-bol-or-indent)

(map! :n
  ;; "-" #'evil-previous-line-first-non-blank) ;; original binding
  "-" #'evil-end-of-line)

(after! evil-snipe
  (setq evil-snipe-scope 'whole-buffer))

(evil-snipe-def 1 'inclusive "t" "T")
(evil-snipe-def 1 'exclusive "f" "F")

;; https://emacs.stackexchange.com/questions/8126/zs-and-ze-from-vim
(defun hscroll-cursor-left ()
  "Scroll horizontally to bring the cursor to the leftmost visible column.
Similar to Vim's `zs'."
  (interactive "@")
  (set-window-hscroll (selected-window) (current-column)))

(defun hscroll-cursor-right ()
  "Scroll horizontally to bring the cursor to the rightmost visible column.
Similar to Vim's `ze'."
  (interactive "@")
  (set-window-hscroll (selected-window) (- (current-column) (window-width) -1)))

(map! :m "zs" 'hscroll-cursor-left)
(map! :m "ze" 'hscroll-cursor-right)
(setq hscroll-margin 0
      hscroll-step 1)
