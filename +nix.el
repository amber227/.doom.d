;;; +nix.el -*- lexical-binding: t; -*-

(defvar nix-system-flake-path
  "~/dotfiles")

(map! :leader
  "n r" #'nix-reload-system-flake
  "n p" #'nix-find-file-in-system-flake
  "n d" #'nix-garbage-collect)

(defun nix-find-file-in-system-flake ()
  (interactive)
  (doom-project-find-file nix-system-flake-path))

(defun nix-reload-system-flake ()
  (interactive)
  (compile (concat "sudo nixos-rebuild switch --flake "  nix-system-flake-path) t))

(defun nix-garbage-collect ()
  (interactive)
  (compile "sudo nix-collect-garbage -d" t))
