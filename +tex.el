;;; +tex.el -*- lexical-binding: t; -*-

(defun tex-recompile-bibliography ()
  (interactive)
  (let* ((tex-roots (TeX-search-files '("./") '("tex") t t))
        (root (when tex-roots
                (car tex-roots))))
    (delete-file (concat root ".aux"))
    (shell-command (concat "pdflatex " root))
    (shell-command (concat "bibtex " root))
    (shell-command (concat "pdflatex " root))
    ;; (shell-command (concat "tex" root ".tex"))
))
