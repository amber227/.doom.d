;;; +python.el -*- lexical-binding: t; -*-

(add-hook 'python-mode-hook (lambda ()
                              (require 'sphinx-doc)
                              (sphinx-doc-mode t)))

(add-hook 'python-mode-hook #'lsp)

(setq sphinx-doc-include-types t)

;; (map! :map python-mode-map
;;   "d" #'sphinx-doc)
