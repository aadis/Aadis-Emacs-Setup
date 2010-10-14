(tool-bar-mode -1)

(defun aaditya/set-screen ()
  (setq default-frame-alist '(
                              (width . 234) 
                              (height . 67)
                              (cursor-type . bar)
                              (cursor-color . "red")))
  (setq initial-frame-alist '(
                              (width . 234) 
                              (height . 67)
                              (cursor-type . bar)
                              (cursor-color . "red")))
  (set-cursor-color "red"))

(aaditya/set-screen)

(toggle-debug-on-error nil)

(show-paren-mode t)
(global-auto-revert-mode t)
(setq-default indent-tabs-mode nil)
(fset 'yes-or-no-p 'y-or-n-p)
(global-set-key (kbd "M-`") 'ns-next-frame)

(setq ns-command-modifier 'meta)

;; make scripts executable
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)

(desktop-save-mode t)

;;use auto compression
(auto-compression-mode 1)

(defadvice save-buffers-kill-emacs (around no-query-kill-emacs activate)
       "Prevent annoying \"Active processes exist\" query when you quit Emacs."
       (flet ((process-list ())) ad-do-it))

;;settings
(setq
 debug-on-error nil
 case-fold-search t
 comint-completion-autolist t
 comint-input-ignoredups t
 comint-prompt-read-only t
 comint-move-point-for-output 'all
 auto-save-directory-fallback "~/.saves"
 set-mark-command-repeat-pop t
 show-paren-mode t
 backup-by-copying t                          ; don't clobber symlinks
 backup-directory-alist '(("." . "~/.saves")) ; don't litter my fs tree
 frame-title-format '(buffer-file-name "%f %+%+" ("%b"))
 blink-cursor-mode t
 save-place t
 scroll-conservatively most-positive-fixnum
 scroll-preserve-screen-position t
 show-paren-mode t
 size-indication-mode t
 sql-electric-stuff 'semicolon
 sql-product 'mysql
 sql-input-ring-file-name "~/.mysql.history"
 sql-password "epsilon"
 sql-pop-to-buffer-after-send-region t
 sql-user "epsilon"
 truncate-partial-width-windows nil
 nxml-slash-auto-complete-flag t
 transient-mark-mode nil
 tramp-default-method "rsync"
 frame-background-mode 'dark
 uniquify-buffer-name-style 'forward)

;;rcirc
(setq
 rcirc-buffer-maximum-lines 10000
 rcirc-default-nick "aadis"
 rcirc-default-user-name "aaditya sood"
 rcirc-server-alist '(("irc.freenode.net" :channels ("#emacs")))
 rcirc-track-minor-mode t)

(defun swap-windows ()
  "If you have 2 windows, it swaps them."
  (interactive)
  (cond ((/= (count-windows) 2)
         (message "You need exactly 2 windows to do this."))
        (t
         (let* ((w1 (first (window-list)))
                (w2 (second (window-list)))
                (b1 (window-buffer w1))
                (b2 (window-buffer w2))
                (s1 (window-start w1))
                (s2 (window-start w2)))
           (set-window-buffer w1 b2)
           (set-window-buffer w2 b1)
           (set-window-start w1 s2)
           (set-window-start w2 s1))))
  (other-window 1))

(global-set-key (kbd "C-c s") 'swap-windows)



;;comint custom stuff
(add-hook 'comint-mode-hook
          (lambda ()
            (message "setting my comint keys")
            (define-key comint-mode-map (kbd "M-p") 'comint-previous-matching-input-from-input)
            (define-key comint-mode-map (kbd "M-n") 'comint-next-matching-input-from-input)
            (define-key comint-mode-map (kbd "C-M-n") 'comint-next-input)
            (define-key comint-mode-map (kbd "C-M-p") 'comint-previous-input)
            (define-key comint-mode-map "\C-w" 'comint-kill-region)
            (define-key comint-mode-map [C-S-backspace] 'comint-kill-whole-line)))


(provide 'aaditya-settings)
