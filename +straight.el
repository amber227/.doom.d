;;; +straight.el -*- lexical-binding: t; -*-

(defun doom--ensure-straight (recipe pin)
  (with-environment-variables
      (("GIT_CONFIG" nil)
       ("GIT_CONFIG_NOSYSTEM" "1")
       ("GIT_CONFIG_GLOBAL" (or (getenv "DOOMGITCONFIG")
                                "/dev/null")))
    (let ((repo-dir (doom-path straight-base-dir "straight/repos/straight.el"))
          (repo-url (concat "http" (if gnutls-verify-error "s")
                            "://github.com/"
                            (or (plist-get recipe :repo) "radian-software/straight.el")))
          (branch (or (plist-get recipe :branch) straight-repository-branch))
          (call (if init-file-debug
                    (lambda (&rest args)
                      (print! "%s" (cdr (apply #'doom-call-process args))))
                  (lambda (&rest args)
                    (apply #'doom-call-process args)))))
      (unless (file-directory-p repo-dir)
        (save-match-data
          (unless (executable-find "git")
            (user-error "Git isn't present on your system. Cannot proceed."))
          (let* ((version (cdr (doom-call-process "git" "version")))
                 (version
                  (and (string-match "\\_<[0-9]+\\.[0-9]+\\(\\.[0-9]+\\)\\_>" version)
                       (match-string 0 version))))
            (if version
                (when (version< version "2.23")
                  (user-error "Git %s detected! Doom requires git 2.23 or newer!"
                              version)))))
        (print! (start "Installing straight..."))
        (print-group!
          (cl-destructuring-bind (depth . options)
              (ensure-list straight-vc-git-default-clone-depth)
            (let ((branch-switch (if (memq 'single-branch options)
                                     "--single-branch"
                                   "--no-single-branch")))
              (cond
               ((eq 'full depth)
                (funcall call "git" "clone" "--origin" "origin"
                         branch-switch repo-url repo-dir))
               ((integerp depth)
                (if (null pin)
                    (progn
                      (when (file-directory-p repo-dir)
                        (delete-directory repo-dir 'recursive))
                      (funcall call "git" "clone" "--origin" "origin" repo-url
                               "--no-checkout" repo-dir
                               "--depth" (number-to-string depth)
                               branch-switch
                               "--no-tags"
                               "--branch" straight-repository-branch))
                  (make-directory repo-dir 'recursive)
                  (let ((default-directory repo-dir))
                    (funcall call "git" "init")
                    (funcall call "git" "branch" "-m" straight-repository-branch)
                    (funcall call "git" "remote" "add" "origin" repo-url
                             "--master" straight-repository-branch)
                    (funcall call "git" "fetch" "origin" pin
                             "--depth" (number-to-string depth)
                             "--no-tags")
                    (funcall call "git" "reset" "--hard" pin)))))))))
      (require 'straight (concat repo-dir "/straight.el"))
      (doom-log "Initializing recipes")
      (mapc #'straight-use-recipes
            '((org-elpa :local-repo nil)
              (melpa              :type git :host github
                                  :repo "melpa/melpa"
                                  :build nil)
              ;; (nongnu-elpa        :type git
              ;;                     :repo "https://git.savannah.gnu.org/git/emacs/nongnu.git"
              ;;                     :local-repo "nongnu-elpa"
              ;;                     :build nil)
              (gnu-elpa-mirror    :type git :host github
                                  :repo "emacs-straight/gnu-elpa-mirror"
                                  :build nil)
              (el-get             :type git :host github
                                  :repo "dimitri/el-get"
                                  :build nil)
              (emacsmirror-mirror :type git :host github
                                  :repo "emacs-straight/emacsmirror-mirror"
                                  :build nil))))))
