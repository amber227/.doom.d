;;; +org.el -*- lexical-binding: t; -*-

(map! :map doom-leader-notes-map
  "h" #'+default/find-in-notes)

(map! :leader
  "x" #'org-add-note
  "n L" #'org-store-link
  "n l" #'my/copy-org-file-link-for-current-buffer
  "n i" #'org-insert-link)

(defun my/copy-org-file-link-for-current-buffer ()
  "Copy an Org file: link to the current buffer's file to the kill ring."
  (interactive)
  (if-let ((f (buffer-file-name)))
      (let* ((link (concat "file:" f))
             (org-link (format "[[%s][%s]]" link (file-name-nondirectory f))))
        (kill-new org-link)
        (message "Copied: %s" org-link))
    (user-error "Current buffer is not visiting a file")))

(defun my/org-move-done-to-top-of-done-block ()
  "When a task is DONE or KILL, move it just below all active siblings.

Among siblings (or top-level headings), keep all non-DONE/non-KILL
items first, then the just-completed one, then other DONE/KILL ones."
  (when (and (boundp 'org-state)
             (member org-state '("DONE" "KILL" "[X]")))
    (save-excursion
      (org-back-to-heading t)
      (let* ((lvl (org-outline-level))
             (done-states '("DONE" "KILL" "[X]")))
        (org-cut-subtree)
        (if (= lvl 1)
            ;; Top-level heading: operate among all level-1 headings in file
            (let ((insert-pos nil))
              (save-excursion
                (goto-char (point-min))
                (while (and (outline-next-heading)
                            (not insert-pos))
                  (when (= (org-outline-level) 1)
                    (let ((st (org-get-todo-state)))
                      (when (member st done-states)
                        (setq insert-pos (point))))))
                (goto-char (or insert-pos (point-max)))
                (unless (bolp) (insert "\n"))
                (org-paste-subtree)))
          ;; Non-top-level: operate among siblings under same parent
          (save-excursion
            ;; Go to parent, then search in its subtree for first DONE/KILL sibling
            (org-up-heading-safe)
            (let ((parent-end (save-excursion
                                (org-end-of-subtree t t)))
                  (insert-pos nil)
                  (target-level (1+ (org-outline-level))))
              (save-excursion
                ;; Move to first child
                (outline-next-heading)
                (while (and (< (point) parent-end)
                            (not insert-pos))
                  (when (= (org-outline-level) target-level)
                    (let ((st (org-get-todo-state)))
                      (when (member st done-states)
                        (setq insert-pos (point)))))
                  (outline-next-heading)))
              (goto-char (or insert-pos parent-end))
              (org-paste-subtree))))))))

(add-hook 'org-after-todo-state-change-hook #'my/org-move-done-to-top-of-done-block)

;; (with-eval-after-load 'org-agenda
;;   (defun my/org-todo-list-no-keyboard-hint (orig-fun &rest args)
;;     "Call `org-todo-list' with `org-agenda-multi' temporarily non-nil
;; to suppress the keyboard hint line in the header."
;;     (let ((org-agenda-multi t))
;;       (apply orig-fun args)))

;;   (advice-add 'org-todo-list :around #'my/org-todo-list-no-keyboard-hint))
(advice-remove 'org-todo-list #'my/org-todo-list-no-keyboard-hint)
