;;; +org.el -*- lexical-binding: t; -*-

(map! :map doom-leader-notes-map
  "h" #'+default/find-in-notes)

(map! :leader
  "x" #'org-add-note)
