;;long running emacs have we, clean up buffers now and then
(require 'midnight)
(midnight-delay-set 'midnight-delay "4:30am")

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

;;better movement via windmove
(require 'windmove)
(windmove-default-keybindings)

;;jshint for on the fly linting of our javascript
(add-to-list 'load-path "/usr/local/lib/node/.npm/jshint-mode/0.0.2/package")
;;(require 'flymake-jshint)
;; (add-hook 'js2-mode-hook
;;     (lambda () (flymake-mode t)))

;;;Those weird days when we edit TeX
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)

(add-hook 'LaTeX-mode-hook 'auto-fill-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)

(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)

(provide 'aaditya-packages)
