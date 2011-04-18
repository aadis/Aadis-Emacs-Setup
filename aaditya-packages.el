

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

(require 'windmove)
(windmove-default-keybindings)


;;(when (load "~/.emacs.d/nxhtml/autostart")
;;  (require 'css-simple-completion)
;;  (autoload 'css-color-mode "css-color" "" t)
;;  (add-hook 'css-mode-hook 'css-color-mode-turn-on))





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

;;(require 'edit-server)
;;(edit-server-start)

;;(when (load-file "~/.emacs.d/color-theme-blackboard.el")
;;  (color-theme-blackboard))

;;use eproject to manage epsilon project
(when (require 'eproject)
  (require 'eproject-extras)
  (define-project-type pylons (generic)
    (look-for "development.ini")
    :relevant-files ("\\.py$" "\\.js$" "\\.html$" "\\.mako$" "\\.css$" "\\.json$" "\\.xml$")
    :irrelevant-files ("public/lib" "public/components" "^gallery-" "^yui2-"))
)

(provide 'aaditya-packages)
