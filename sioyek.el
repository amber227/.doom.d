;;; sioyek.el -*- lexical-binding: t; -*-

;; https://github.com/ahrm/sioyek/discussions/347
;; Integrate with sioyek database, ~/.local/share/sioyek/{local, shared}.db sqlite files
(sqlite-open "~/.local/share/sioyek/shared.db")
