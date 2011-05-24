;;(tool-bar-mode -1)

(setq ido-everywhere t)
(ido-mode 1)
;; File finding
(global-set-key (kbd "C-x M-f") 'ido-find-file-other-window)

(setq vc-handled-backends nil)

;; Use regex searches by default.
(global-set-key "\C-s" 'isearch-forward-regexp)
(global-set-key "\C-r" 'isearch-backward-regexp)
(global-set-key "\C-\M-s" 'isearch-forward)
(global-set-key "\C-\M-r" 'isearch-backward)

(set-scroll-bar-mode 'right)


(defun aaditya/set-screen ()
  (interactive)
  (setq default-frame-alist '(
                              (top . 20) (left . 1)
                              ;; (width . 234)
                              ;; (height . 77)
                              (cursor-type . (bar . 3))
                              (cursor-color . "red")))
  (setq initial-frame-alist '(
                              (top . 10) (left . 1)
                              ;; (width . 234)
                              ;; (height . 77)
                              (cursor-type . (bar . 3))
                              (cursor-color . "red")))
  (set-cursor-color "red"))

(aaditya/set-screen)

(setq split-height-threshold nil
      split-width-threshold most-positive-fixnum)

(show-paren-mode t)
(global-auto-revert-mode t)
(setq-default indent-tabs-mode nil)
(fset 'yes-or-no-p 'y-or-n-p)
(global-set-key (kbd "M-`") 'ns-next-frame)

(setq ns-command-modifier 'meta)

;; make scripts executable
;; (add-hook 'after-save-hook
;;           'executable-make-buffer-file-executable-if-script-p)

;; (desktop-save-mode t)
;; (setq history-length 250)
;; (add-hook 'auto-save-hook (lambda () (desktop-save-in-desktop-dir)))
;; (add-to-list 'desktop-globals-to-save 'file-name-history)
;; (setq desktop-buffers-not-to-save
;;       (concat "\\("
;;               "^nn\\.a[0-9]+\\|\\.log\\|(ftp)\\|^tags\\|^TAGS"
;;               "\\|\\.emacs.*\\|\\.diary\\|\\.newsrc-dribble\\|\\.bbdb"
;;               "\\)$"))
;; (add-to-list 'desktop-modes-not-to-save 'dired-mode)
;; (add-to-list 'desktop-modes-not-to-save 'Info-mode)
;; (add-to-list 'desktop-modes-not-to-save 'info-lookup-mode)
;; (add-to-list 'desktop-modes-not-to-save 'fundamental-mode)

;;use auto compression
;;(auto-compression-mode 1)

;; (defadvice save-buffers-kill-emacs (around no-query-kill-emacs activate)
;;        "Prevent annoying \"Active processes exist\" query when you quit Emacs."
;;        (flet ((process-list ())) ad-do-it))

(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-c\C-k" 'kill-region)

(when (require 'misc nil t)
  (global-set-key "\M-z" 'zap-up-to-char))

;;recentf
(recentf-mode 1)
(setq recentf-max-saved-items 500)
(setq recentf-max-menu-items 60)
(global-set-key [(f5)] 'recompile)
(global-set-key [(control f5)] 'compile)

(defun notify-compilation-result(buffer msg)
  "Notify that the compilation is finished,
close the *compilation* buffer if the compilation is successful,
and set the focus back to Emacs frame"
  (if (string-match "^finished" msg)
    (progn
     ;;(delete-windows-on buffer)
      (if (fboundp 'ecb-toggle-compile-window)
          (ecb-toggle-compile-window 0))
     (shell-command "growlnotify -m \"build OK\" -n Emacs -d Emacs -i js")
     (tooltip-show "\n Compilation Successful :-) \n "))
    (progn
      (shell-command "growlnotify -m \"build FAILED\" -p 5 -d Emacs -n Emacs -i java")
      (tooltip-show "\n Compilation Failed :-( \n ")))
  (setq current-frame (car (car (cdr (current-frame-configuration)))))
  (select-frame-set-input-focus current-frame)
  )

(add-to-list 'compilation-finish-functions
	     'notify-compilation-result)


(defun xsteve-ido-choose-from-recentf ()
  "Use ido to select a recently opened file from the `recentf-list'"
  (interactive)
  (let ((home (expand-file-name (getenv "HOME"))))
    (find-file
     (ido-completing-read "Recentf open: "
                          (mapcar (lambda (path)
                                    (replace-regexp-in-string home "~" path))
                                  recentf-list)
                          nil t))))

(global-set-key [(f6)] 'xsteve-ido-choose-from-recentf)

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
 frame-background-mode 'light
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

(global-set-key [(f7)] 'swap-windows)



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


;;whitespace stuff
(require 'whitespace)
;; nuke trailing whitespaces when writing to a file
;;(add-hook 'write-file-hooks 'delete-trailing-whitespace)

;; display only tails of lines longer than 80 columns, tabs and
;; trailing whitespaces
(setq whitespace-line-column 80
      whitespace-style '(tabs trailing lines-tail))

;; face for long lines' tails
(set-face-attribute 'whitespace-line nil
                    :background "red1"
                    :foreground "yellow"
                    :weight 'bold)

;; face for Tabs
(set-face-attribute 'whitespace-tab nil
                    :background "red1"
                    :foreground "yellow"
                    :weight 'bold)

;; activate minor whitespace mode when in python mode
;;(add-hook 'python-mode-hook 'whitespace-mode)

(provide 'aaditya-settings)
