;; File finding
(global-set-key (kbd "C-x M-f") 'ido-find-file-other-window)

;;(setq vc-handled-backends nil)

;; Use regex searches by default.
(global-set-key "\C-s" 'isearch-forward-regexp)
(global-set-key "\C-r" 'isearch-backward-regexp)
(global-set-key "\C-\M-s" 'isearch-forward)
(global-set-key "\C-\M-r" 'isearch-backward)
(global-set-key (kbd "<f3>") 'eshell)

(set-scroll-bar-mode 'right)

;; I like truncated lines, this fact i cannot deny

(add-hook 'ido-minibuffer-setup-hook
	  (lambda ()
	    (setq truncate-lines nil)))
(setq-default truncate-lines t)
(setq truncate-partial-width-windows nil) ;; for vertically-split windows

(dolist (hook '(erc-mode-hook
                LaTeX-mode-hook
                edit-server-start-hook
                markdown-mode-hook
                twittering-mode
                text-mode
                fundamental-mode))
  (add-hook hook (lambda () (variable-pitch-mode t))))


(blink-cursor-mode t)

(setq split-height-threshold nil
      split-width-threshold most-positive-fixnum)

;;rsyncc uses OpenSSH ControlMaster, which I use
(setq tramp-default-method "rsyncc")

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;;delete trailing whitespaces
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;;server stuff
(require 'server)
(defvar server-buffer-clients)
(when (and (fboundp 'server-start) (not (server-running-p)))
  (server-start)
  (defun fp-kill-server-with-buffer-routine ()
    (and server-buffer-clients (server-done)))
  (add-hook 'kill-buffer-hook 'fp-kill-server-with-buffer-routine))

(show-paren-mode t)
(global-auto-revert-mode t)
(setq-default indent-tabs-mode nil)
(fset 'yes-or-no-p 'y-or-n-p)
(global-set-key (kbd "M-`") 'ns-next-frame)
(global-set-key (kbd "C-x g") 'magit-status)

(setq ns-command-modifier 'meta)

(when (require 'misc nil t)
  (global-set-key "\M-z" 'zap-up-to-char))

;;recentf
(recentf-mode 1)
(setq recentf-max-saved-items 500)
(setq recentf-max-menu-items 60)
(global-set-key [(f5)] 'recompile)
(global-set-key [(control f5)] 'compile)

(setenv "ESHELL" (expand-file-name "/bin/bash"))

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
 frame-title-format '((:eval (if (buffer-file-name)
                                 (abbreviate-file-name (buffer-file-name))
                               "%b")) " [%*] %@")
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
 transient-mark-mode t
 mark-even-if-inactive t
 tramp-default-method "rsync"
 frame-background-mode 'light
 uniquify-buffer-name-style 'forward)

(setq tramp-backup-directory-alist backup-directory-alist)

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
            (setq truncate-lines t)
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

;;use ibuffer
(defalias 'list-buffers 'ibuffer)

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

(follow-mode t)

;; activate minor whitespace mode when in python mode
;;(add-hook 'python-mode-hook 'whitespace-mode)

;; Hindu Holidays (North India/Nepal)

(setq holiday-other-holidays
'(
  (holiday-fixed 1 14  "Makar Sankranti")
  (holiday-fixed 2 8   "Vasant Panchami / Saraswati Puja")
  (holiday-fixed 3 3   "Maha Shivaratri")
  (holiday-fixed 3 19  "Holi")
  (holiday-fixed 4 4   "Bikrami Samvat / Hindu New Year [2068]")
  (holiday-fixed 4 12  "Ram Navmi")
  (holiday-fixed 4 18  "Hanuman Jayanti")
  (holiday-fixed 5 6   "Akshaya Tritiya (Akha Teej)")
  (holiday-fixed 6 15  "Savitri Puja")
  (holiday-fixed 7 15  "Guru Purnima")
  (holiday-fixed 8 4   "Naag Panchami")
  (holiday-fixed 8 12  "Mahalakshmi Vrata")
  (holiday-fixed 8 13  "Raksha-Bandhan + Janai Purnima")
  (holiday-fixed 8 22  "Krishna Janmashtami")
  (holiday-fixed 9 1   "Ganesh Chaturthi")
  (holiday-fixed 9 9   "Indra Jatra begins")
  (holiday-fixed 9 11  "Kumari Indra Jatra")
  (holiday-fixed 9 17  "Indra Jatra ends")
  (holiday-fixed 9 11  "Teej")
  (holiday-fixed 9 13  "Pitr-Paksha begins")
  (holiday-fixed 9 27  "Mahalaya (Pitr-Paksha ends)")
  (holiday-fixed 9 28  "Navaratri begins")
  (holiday-fixed 10 3  "Durga Puja begins (Maha Saptami)")
  (holiday-fixed 10 5  "Navaratri ends")
  (holiday-fixed 10 6  "Dasain/Dusshera (Vijaya Dashami)")
  (holiday-fixed 10 11 "Lakshmi Puja (Sharad Purnima)")
  (holiday-fixed 10 16 "Karwa Chauth")
  (holiday-fixed 10 25 "Dhan Teras")
  (holiday-fixed 10 26 "Diwali / Deepavali / Tihar")
  (holiday-fixed 10 28 "Bhai Dooj")
  )
)

;;allow max on OS X
(defun get-frame-max-lines ()
  (-
   (/
    (* (- (display-pixel-height) 20) (frame-height))
    (frame-pixel-height)) 2))

(defun get-frame-max-cols ()
  (-
   (/
    (* (display-pixel-width) (frame-width))
    (frame-pixel-width))
   0  ))

(defun maximize-frame ()
  (interactive)
  (set-frame-position (selected-frame) 0 20)
  (set-frame-size (selected-frame) (get-frame-max-cols) (get-frame-max-lines)))

(defun halve-frame-h ()
  (interactive)
  (set-frame-position (selected-frame) 0 20)
  (set-frame-size (selected-frame) (/ (frame-width) 2) (frame-height)))

(defun halve-frame-v ()
  (interactive)
  (set-frame-position (selected-frame) 0 20)
  (set-frame-size (selected-frame) (frame-width) (/ (frame-height) 2)))

(global-set-key (kbd "C-|") 'maximize-frame)
(global-set-key (kbd "C->") 'halve-frame-h)
(global-set-key (kbd "C-<") 'halve-frame-v)

(provide 'aaditya-settings)
