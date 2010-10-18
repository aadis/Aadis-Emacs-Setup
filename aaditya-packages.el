(setq ido-everywhere t)
(require 'ido)
(ido-mode t)

(recentf-mode t)

(require 'edit-server)
(edit-server-start)

(setq elscreen-display-tab 45)

(require 'elscreen)
;;(require 'elscreen-color-theme)
(require 'elscreen-dired)
(require 'elscreen-server)

(global-set-key (kbd "C-z C-z") 'elscreen-toggle)

(require 'color-theme)
(color-theme-initialize)
(when (load "color-theme-subdued" t)
  (color-theme-subdued))

(require 'winner)
(winner-mode 1)
;;window configs are pretty important
(setq winner-boring-buffers '("*Completions*"
                              "*Compile-Log*"
                              "*Traverse-directory*"
                              "*Apropos*"
                              "*Messages*"
                              "*anything*"
                              "*anything complete*"
                              "*Anything Occur*"
                              "*Help*"
                              "*Buffer List*"
                              "*Ibuffer*"
                              "*irc.freenode.net*"
                              ))

(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;;scratch
(require 'scratch)

(require 'regex-tool)

(require 'windmove)
(windmove-default-keybindings)

(require 'visible-mark)
(global-visible-mark-mode t)

(require 'sql-completion)
(setq sql-interactive-mode-hook
      (lambda ()
        (define-key sql-interactive-mode-map "\t" 'comint-dynamic-complete)
        (toggle-truncate-lines)
        (sql-mysql-completion-init)))

(require 'magit)
(global-set-key (kbd "C-x g") 'magit-status)

(require 'git-blame)

;; Use regex searches by default.
(global-set-key "\C-s" 'isearch-forward-regexp)
(global-set-key "\C-r" 'isearch-backward-regexp)
(global-set-key "\C-\M-s" 'isearch-forward)
(global-set-key "\C-\M-r" 'isearch-backward)

;; File finding
(global-set-key (kbd "C-x M-f") 'ido-find-file-other-window)

(when (load "sml-modeline")    ;; use sml-modeline if available
  (sml-mode 1))                 ;; show buffer pos in the mode line

(set-scroll-bar-mode 'right)

(load "~/.emacs.d/nxhtml/autostart")


(require 'js2-mode)
(setq
 js2-basic-offset 4
 js2-highlight-level 3
 js2-indent-on-enter-key t)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

(autoload 'moz-minor-mode "moz" "Mozilla Minor and Inferior Mozilla Modes" t)

(defun js2-custom-setup ()
  (moz-minor-mode 1))
(add-hook 'js2-mode-hook 'js2-custom-setup)

(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)

(add-hook 'LaTeX-mode-hook 'auto-fill-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)

(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)

(require 'midnight)
(midnight-delay-set 'midnight-delay "4:30am")

(provide 'aaditya-packages)
