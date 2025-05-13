;;; templates.el -*- lexical-binding: t; -*-

(defun template ()
  (interactive)
  (setq name (read-string "Directory name: "))
  (setq dir (concat "~/projects/cp/" problem-name))
  (copy-directory "~/projects/cp/template/" dir)
  (find-file (concat dir "/main.py")))
