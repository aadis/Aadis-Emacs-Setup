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
;;(add-to-list 'load-path "/usr/local/lib/node/.npm/jshint-mode/0.0.2/package")
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

;;stop blowing up ipython 0.11
;;(setq py-python-command-args '(""))

;;use ack-and-a-half
(autoload 'ack-and-a-half-same "ack-and-a-half" nil t)
(autoload 'ack-and-a-half "ack-and-a-half" nil t)
(autoload 'ack-and-a-half-find-file-samee "ack-and-a-half" nil t)
(autoload 'ack-and-a-half-find-file "ack-and-a-half" nil t)
;; Create shorter aliases
(defalias 'ack 'ack-and-a-half)
(defalias 'ack-same 'ack-and-a-half-same)
(defalias 'ack-find-file 'ack-and-a-half-find-file)
(defalias 'ack-find-file-same 'ack-and-a-half-find-file-same)

;;edit server for chrome integration
;; (require 'edit-server)
;; (edit-server-start)

;;use textile mode for editing redmine
(defun set-nice-prop-font ()
  (buffer-face-set 'variable-pitch))
(add-hook 'textile-mode-hook 'set-nice-prop-font)

(when (require 'ace-jump-mode nil 'noerror)
  (define-key global-map (kbd "C-c SPC") 'ace-jump-mode)
  (add-hook 'ace-jump-mode-before-jump-hook
            (lambda () (push-mark (point) t))) ;until it's fixed in Maramalade
  )


;; ;;we want to run py.test pretty regularly
(defun aadis/load-pytest ()
  (interactive)
  (when (require 'pytest nil 'noerror)
    (setq pytest-global-name "py.test")
    (setq pytest-use-verbose nil) ; non-verbose output
    (setq pytest-loop-on-failing nil) ; don't use the -f flag from xdist
    (setq pytest-assert-plain t) ; don't worry about re-evaluating exceptions (faster)
    (setq pytest-cmd-flags "--durations=3")

    (add-hook 'python-mode-hook
              (lambda ()
                (local-set-key "\C-ca" 'pytest-all)
                (local-set-key "\C-cm" 'pytest-module)
                (local-set-key "\C-c." 'pytest-one)
                (local-set-key "\C-cd" 'pytest-directory)
                (local-set-key "\C-cpa" 'pytest-pdb-all)
                (local-set-key "\C-cpm" 'pytest-pdb-module)
                (local-set-key "\C-cp." 'pytest-pdb-one)))
    ))

(require 'thingatpt)
(require 'imenu)

(defun mine-goto-symbol-at-point ()
  "Will navigate to the symbol at the current point of the cursor"
  (interactive)
  (ido-goto-symbol (thing-at-point 'symbol)))

(defun ido-goto-symbol (&optional a-symbol)
  "Will update the imenu index and then use ido to select a symbol to navigate to"
  (interactive)
  (imenu--make-index-alist)
  (let ((name-and-pos '())
        (symbol-names '()))
    (flet ((addsymbols (symbol-list)
                       (when (listp symbol-list)
                         (dolist (symbol symbol-list)
                           (let ((name nil) (position nil))
                             (cond
                              ((and (listp symbol) (imenu--subalist-p symbol))
                               (addsymbols symbol))

                              ((listp symbol)
                               (setq name (car symbol))
                               (setq position (cdr symbol)))

                              ((stringp symbol)
                               (setq name symbol)
                               (setq position (get-text-property 1 'org-imenu-marker symbol))))

                             (unless (or (null position) (null name))
                               (add-to-list 'symbol-names name)
                               (add-to-list 'name-and-pos (cons name position))))))))
      (addsymbols imenu--index-alist))
    (let* ((selected-symbol
            (if (null a-symbol)
                (ido-completing-read "Symbol? " symbol-names)
              a-symbol))
           (position (cdr (assoc selected-symbol name-and-pos))))
      (cond
       ((overlayp position)
        (goto-char (overlay-start position)))
       (t
        (goto-char position))))))

;; optionally bind these to key chords
(global-set-key "\C-cs"     'ido-goto-symbol)
(global-set-key "\C-cp"     'mine-goto-symbol-at-point)

(provide 'aaditya-packages)
