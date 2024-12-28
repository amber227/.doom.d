;;; +proof-mode.el -*- lexical-binding: t; -*-

(after! coq-mode
  (map! :map coq-mode-map :localleader
        "." 'proof-assert-dwim-interactive
        "'" 'proof-assert-dwim-snap-back-interactive
        "e" 'proof-assert-until-point-interactive
        "," 'proof-retract-dwim
        "j" 'proof-next-statement-interactive
        "k" 'proof-previous-statement-interactive)
  (map! :map company-coq-map
        "C-<return>" 'proof-assert-until-point-interactive))

(after! proof-mode
  ;; Tailored for doom-spacegrey
  (custom-set-faces
   '(proof-locked-face ((t (:background "#403e54"))))
   '(proof-queue-face ((t (:background "#47435c"))))))

(defun proof-next-statement-interactive (count)
  (interactive "P")
  (dotimes (_ (or count 1)) (proof-next-statement)))

(defun proof-previous-statement-interactive (count)
  (interactive "P")
  (dotimes (_ (or count 1)) (proof-previous-statement)))

(defun proof-assert-dwim-interactive (count)
  (interactive "P")
  (dotimes (_ (or count 1)) (proof-assert-dwim nil)))

(defun proof-assert-dwim-snap-back-interactive (count)
  (interactive "P")
  (dotimes (_ (or count 1)) (proof-assert-dwim t)))

;; If inside locked region, jump to next unlocked statement
;; then execute. If outside locked region, execute up to point
(defun proof-assert-dwim (snap-back-when-outside)
  (cond ((>= (point) (proof-queue-or-locked-end))
         (if (eq ?. (char-after))
             ;; We're outside the locked region and on top of a dot
             (proof-assert-until-point)
           ;; Jump to end of current statement, then execute.
           ;; TODO: use regex to ignore periods in comments
           (if snap-back-when-outside
               (proof-previous-statement)
             (proof-next-statement))
           (proof-assert-until-point)))
        ;; We're at the end of the locked region
        ((= (point) (- (proof-queue-or-locked-end) 1))
         (proof-next-statement)
         (proof-assert-until-point))
        ;; We're inside the locked region. Jump to end,
        ;; then find next statement to execute
        (t (message "End of locked region.")
        (goto-char (- (proof-queue-or-locked-end) 1)))))

(defun proof-retract-dwim ()
  (interactive)
  (cond ((>= (point) (proof-queue-or-locked-end))
         (message "End of locked region.")
         (goto-char (- (proof-queue-or-locked-end) 1)))

         ((= (point) (- (proof-queue-or-locked-end) 1))
          (message "2")
          (proof-retract-until-point))

         (t (message "3") (if (and (eq ?. (char-after)) (not (proof-point-inside-comment)))
                (proof-retract-until-point)
              (proof-previous-statement)
              (proof-retract-until-point))))

  ;; Wait a tiny bit before jumping. Locked end doesn't
  ;; get updated in time otherwise and we don't move.
  (sleep-for 0 2) ;; 2ms
  (goto-char (- (proof-queue-or-locked-end) 1)))

(defun proof-next-statement ()
  (proof-search-forward-skip-comments "."))

(defun proof-previous-statement ()
  (proof-search-backward-skip-comments "."))

(defun proof-search-forward-skip-comments (char)
  (while (and (progn (forward-char) (search-forward char nil t))
              (proof-point-inside-comment)))
  (unless (eolp) (backward-char)))

(defun proof-search-backward-skip-comments (char)
  (while (and (progn (search-backward char nil t))
              (proof-point-inside-comment))))

;; TODO: wrong behavior on both boundaries
;; Returns t if point is inside a Coq comment, else nil
(defun proof-point-inside-comment ()
  (let ((original) (search-succeeded) (result)))
  (setq original (point))
  (setq search-succeeded
        (re-search-forward "\(\\*\\|\\*\)" nil t))
  (if (not search-succeeded)
      (setq result nil)
    (pcase (match-string 0)
      ("(*" (setq result nil))
      ("*)" (setq result t))))
  (goto-char original)
  result)
