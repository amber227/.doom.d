;;; +git.el -*- lexical-binding: t; -*-

(map! :leader
  "g P" #'magit-push
  "g p" #'magit-pull
  "g d" #'magit-diff
  "g g" #'magit-status-full
  "g e" #'flymake-goto-next-error
  "g E" #'flymake-goto-prev-error
  "g k" #'+vc-gutter/previous-hunk
  "g j" #'+vc-gutter/next-hunk
  "g c a" #'magit-commit-amend
  "g ." #'magit-status-full
  "g >" #'magit-status-truncated
  "g ," #'magit-file-dispatch)

(map! :map magit-mode-map
  "." #'magit-status-toggle-truncated)

(setq magit-truncate-status t)

(setq magit-status-sections-hook-truncated
      '(
        magit-insert-status-headers
        ;; magit-insert-merge-log
        ;; magit-insert-rebase-sequence
        magit-insert-am-sequence
        magit-insert-sequencer-sequence
        magit-insert-bisect-output
        magit-insert-bisect-rest
        magit-insert-bisect-log
        ;; magit-insert-untracked-files
        magit-insert-unstaged-changes
        magit-insert-staged-changes
        ;; magit-insert-stashes
        ;; magit-insert-unpushed-to-pushremote
        ;; magit-insert-unpushed-to-upstream-or-recent
        ;; magit-insert-unpulled-from-pushremote
        ;; magit-insert-unpulled-from-upstream
        ))

(setq magit-status-headers-hook-truncated
      '(magit-insert-error-header
        ;; magit-insert-diff-filter-header
        magit-insert-head-branch-header
        ;; magit-insert-upstream-branch-header
        ;; magit-insert-push-branch-header
        ;; magit-insert-tags-header
        ))

(setq magit-status-sections-hook-full
      '(
        magit-insert-status-headers
        magit-insert-merge-log
        magit-insert-rebase-sequence
        magit-insert-am-sequence
        magit-insert-sequencer-sequence
        magit-insert-bisect-output
        magit-insert-bisect-rest
        magit-insert-bisect-log
        magit-insert-untracked-files
        magit-insert-unstaged-changes
        magit-insert-staged-changes
        magit-insert-stashes
        magit-insert-unpushed-to-pushremote
        magit-insert-unpushed-to-upstream-or-recent
        magit-insert-unpulled-from-pushremote
        magit-insert-unpulled-from-upstream
        ))

(setq magit-status-headers-hook-full
      '(magit-insert-error-header
        magit-insert-diff-filter-header
        magit-insert-head-branch-header
        magit-insert-upstream-branch-header
        magit-insert-push-branch-header
        magit-insert-tags-header
        ))

;; Generating the full status is annoyingly slow;
;; only show barebones status features on toggle.
(defun magit-status-toggle-truncated ()
  "Show the full magit status buffer"
  (interactive)
  (if magit-truncate-status
      (progn (setq magit-truncate-status nil)
             (setq magit-status-sections-hook
                   magit-status-sections-hook-full)
             (setq magit-status-headers-hook
                   magit-status-headers-hook-full))
    (setq magit-truncate-status t)
    (setq magit-status-sections-hook
          magit-status-sections-hook-truncated)
    (setq magit-status-headers-hook
          magit-status-headers-hook-truncated))

  (magit-status))

(defun magit-status-truncated ()
  (interactive)
  (setq magit-truncate-status t)
  (setq magit-status-sections-hook
        magit-status-sections-hook-truncated)
  (setq magit-status-headers-hook
        magit-status-headers-hook-truncated)

  (magit-status))

(defun magit-status-full ()
  (interactive)
  (setq magit-truncate-status nil)
  (setq magit-status-sections-hook
        magit-status-sections-hook-full)
  (setq magit-status-headers-hook
        magit-status-headers-hook-full)

  (magit-status))

(defun ediff-copy-both-to-C ()
  (interactive)
  (ediff-copy-diff ediff-current-difference nil 'C nil
                   (concat
                    (ediff-get-region-contents ediff-current-difference 'A ediff-control-buffer)
                    (ediff-get-region-contents ediff-current-difference 'B ediff-control-buffer))))
(defun add-d-to-ediff-mode-map () (define-key ediff-mode-map "d" 'ediff-copy-both-to-C))
(add-hook 'ediff-keymap-setup-hook 'add-d-to-ediff-mode-map)
