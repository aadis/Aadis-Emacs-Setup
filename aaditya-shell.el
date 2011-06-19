(defvar my-shells
  '("*snarfed*" "*shell0*" "*shell1*" "*shell2*" "*music*"))

(require 'tramp)

(setq
 tramp-default-method "ssh"          ; uses ControlMaster
 comint-scroll-to-bottom-on-input t  ; always insert at the bottom
 comint-scroll-to-bottom-on-output nil ; always add output at the bottom
 comint-scroll-show-maximum-output t ; scroll to show max possible output
 comint-completion-autolist t        ; show completion list when ambiguous
 comint-input-ignoredups t           ; no duplicates in command history
 comint-completion-addsuffix t       ; insert space/slash after file completion
 comint-buffer-maximum-size 100000   ; max length of the buffer in lines
 comint-prompt-read-only nil         ; if this is t, it breaks shell-command
 comint-get-old-input (lambda () "") ; what to run when i press enter on a
                                     ; line above the current prompt
 comint-input-ring-size 5000         ; max shell history size
 protect-buffer-bury-p nil
)

;; truncate buffers continuously
(add-hook 'comint-output-filter-functions 'comint-truncate-buffer)

;; make stdout read only, but only in my shells
(defun make-my-shell-output-read-only (text)
  (if (member (buffer-name) my-shells)
      (let ((inhibit-read-only t)
            (output-end (process-mark (get-buffer-process (current-buffer)))))
        (put-text-property comint-last-output-start output-end 'read-only t))))
(add-hook 'comint-output-filter-functions 'make-my-shell-output-read-only)

;; use dirtrack mode but not in the tramp shell
(defun dirtrack-mode-locally ()
  (when (member (buffer-name) (cdr my-shells))
    (dirtrack-mode t)
    (set-variable 'dirtrack-list '("^[A-Za-z0-9]+:\\([~/][^\\n>]*\\)>" 1 nil))))
(add-hook 'shell-mode-hook 'dirtrack-mode-locally)

; interpret and use ansi color codes in shell output windows
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

; don't jump-scroll when i enter a newline in a shell command
(defun set-scroll-conservatively ()
  (set (make-local-variable 'scroll-conservatively) 10))
(add-hook 'shell-mode-hook 'set-scroll-conservatively)

; don't switch away from the shell when emacsclient opens a new buffer
(defun unset-display-buffer-reuse-frames ()
  (set (make-local-variable 'display-buffer-reuse-frames) t))
(add-hook 'shell-mode-hook 'unset-display-buffer-reuse-frames)

;; make it harder to kill my shell buffers
;;(require 'protbuf)
;;(add-hook 'shell-mode-hook 'protect-buffer-from-kill-mode)

;; this makes directory tracking work while sshed into a remote host, e.g. for
;; remote shell buffers started in tramp. TODO: remove once i'm on emacs 24:
;; http://comments.gmane.org/gmane.emacs.bugs/39082
(defun make-comint-directory-tracking-work-remotely ()
  (set (make-local-variable 'comint-file-name-prefix)
       (or (file-remote-p default-directory) "")))
(add-hook 'comint-mode-hook 'make-comint-directory-tracking-work-remotely)

;; function and advice to automatically close the completions buffer as soon as
;; i'm done with it. based on Dmitriy Igrishin <dmitigr@gmail.com>'s patched
;; version of comint.el, which i converted to advice.
(defun comint-close-completions ()
  (if comint-dynamic-list-completions-config
      (progn
        (set-window-configuration comint-dynamic-list-completions-config)
        (setq comint-dynamic-list-completions-config nil))))

(defadvice comint-send-input (after close-completions activate)
  (comint-close-completions))

(defadvice comint-dynamic-complete-as-filename (after close-completions activate)
  (if ad-return-value (comint-close-completions)))

(defadvice comint-dynamic-simple-complete (after close-completions activate)
  (if (member ad-return-value '('sole 'shortest 'partial))
      (comint-close-completions)))

(defadvice comint-dynamic-list-completions (after close-completions activate)
    (comint-close-completions)
    (if (not unread-command-events)
        ;; comint's "Type space to flush" swallows space. put it back in.
        (setq unread-command-events (listify-key-sequence " "))))

;; in emacs's built in minibuf isearch and in shell-mode history isearch (from
;; comint.el), make enter select the current item.
;; (another approach would be after-advice on isearch-other-meta-char.)
(defun enter-again-if-enter ()
  (when (and (not isearch-mode-end-hook-quit)
             (equal (this-command-keys-vector) [13])) ; == return
    (cond ((active-minibuffer-window) (minibuffer-complete-and-exit))
          ((member (buffer-name) my-shells) (comint-send-input)))))
(add-hook 'isearch-mode-end-hook 'enter-again-if-enter)

;; suppress the annoying "History item : NNN" messages from
;; comint-previous-matching-input when regexp searching history.
;;
;; (if this isn't enough, try the same thing with
;; comint-replace-by-expanded-history-before-point.)
(defadvice comint-previous-matching-input
    (around suppress-history-item-messages activate)
  (let ((old-message (symbol-function 'message)))
    (unwind-protect
      (progn (fset 'message 'ignore) ad-do-it)
    (fset 'message old-message))))

(provide 'aaditya-shell)
