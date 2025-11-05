;;; +aider.el -*- lexical-binding: t; -*-

(use-package transient)

(use-package aider
  :after transient
  :config
  (require 'aider-doom))
