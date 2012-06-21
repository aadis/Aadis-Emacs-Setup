(setq message-log-max 2000)

;;load up ido first, need it pretty much always
(require 'ido)
(setq ido-everywhere t)
(setq ido-default-buffer-method 'selected-window)
(ido-mode 1)

;;we want a bar cursor
(setq-default cursor-type '(bar . 2))

;;setup some initial load paths
(add-to-list 'load-path "~/.emacs.d/")

(add-to-list 'load-path "~/src/local/share/emacs/site-lisp/gnus")
(add-to-list 'load-path "~/src/local/share/emacs/site-lisp/gnus")

;;our package sources
(setq package-archives (quote (("gnu" . "http://elpa.gnu.org/packages/")
                               ("elpa" . "http://tromey.com/elpa/")
                               ("marmalade" . "http://marmalade-repo.org/packages/")
                               ("melpa" . "http://melpa.milkbox.net/packages/")
			       )))
;;load up our newer python mode always
;; (load (expand-file-name "~/.emacs.d/python"))
;; (setq
;;  ;;python-shell-virtualenv-path (expand-file-name "~/.virtualenvs/rp/")
;;       python-shell-interpreter "ipython"
;;       python-shell-interpreter-args ""
;;       python-shell-prompt-regexp "In \\[[0-9]+\\]: "
;;       python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
;;       python-shell-completion-setup-code
;;       "from IPython.core.completerlib import module_completion"
;;       python-shell-completion-module-string-code
;;       "';'.join(module_completion('''%s'''))\n"
;;       python-shell-completion-string-code
;;       "';'.join(get_ipython().Completer.all_completions('''%s'''))\n")

;; (require 'virtualenv)



;;load newer cedet
(load-file "~/src/local/cedet/cedet-devel-load.el")
;; Add further minor-modes to be enabled by semantic-mode.
;; See doc-string of `semantic-default-submodes' for other things
;; you can use here.
(add-to-list 'semantic-default-submodes 'global-semantic-idle-summary-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-completions-mode)

;; Enable Semantic
(semantic-mode 1)

(require 'package)
(package-initialize)

(defadvice package-compute-transaction
  (before
   package-compute-transaction-reverse (package-list requirements)
   activate compile)
  "reverse the requirements"
  (setq requirements (reverse requirements))
  (print requirements))

(defadvice package-download-tar
  (after package-download-tar-initialize activate compile)
  "initialize the package after compilation"
  (package-initialize))

(defadvice package-download-single
  (after package-download-single-initialize activate compile)
  "initialize the package after compilation"
  (package-initialize))

;;we're now going to be using el-get to install packages we want
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil t)
  (with-current-buffer
(url-retrieve-synchronously
 "https://raw.github.com/dimitri/el-get/master/el-get-install.el"
 (lambda (s)
   (let (el-get-master-branch)
     (end-of-buffer)
     (eval-print-last-sexp))))))

(setq el-get-sources
      '(
        ;; (:name magit
	;; 	:after (lambda ()
	;; 		 (require 'magit)
	;; 		 (global-set-key (kbd "C-x g") 'magit-status)))
	 (:name pymacs
	        :after (progn
	        	 (setq pymacs-python-command (expand-file-name "~/work/meghdoot/lib/buildout/parts/pip/bin/python"))
	        	 (require 'pymacs)))
	 (:name ropemacs
	        :after (progn
                         (pymacs-load "ropemacs" "rope-")
	        	 (setq ropemacs-confirm-saving nil
	        	       ropemacs-guess-project t
	        	       ropemacs-enable-autoimport t)))
         (:name python
                :after (progn
                         (setq
                          ;;python-shell-virtualenv-path (expand-file-name "~/.virtualenvs/rp/")
                          python-shell-interpreter "ipython"
                          python-shell-interpreter-args ""
                          python-shell-prompt-regexp "In \\[[0-9]+\\]: "
                          python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
                          python-shell-completion-setup-code
                          "from IPython.core.completerlib import module_completion"
                          python-shell-completion-module-string-code
                          "';'.join(module_completion('''%s'''))\n"
                          python-shell-completion-string-code
                          "';'.join(get_ipython().Completer.all_completions('''%s'''))\n")
                         ))
         (:name ecb
                :after (progn
                         (setq stack-trace-on-error t)
                         (require 'ecb)
                         ))
	 (:name smex
		:after (progn
			 (require 'smex)
			 (smex-initialize)
			 (global-set-key (kbd "M-x") 'smex)
			 (global-set-key (kbd "M-X") 'smex-major-mode-commands)
			 ;; This is your old M-x.
			 (global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)))
	 (:name sml-modeline
		:after (progn
			 (require 'sml-modeline nil t)    ;; use sml-modeline if available
			 (sml-modeline-mode 1)))
	 (:name js2-mode
		:after (progn
			 (require 'js2-mode)
			 (setq  js2-basic-offset 4
				js2-highlight-level 2
				js2-indent-on-enter-key t)
			 (add-hook 'js2-mode-hook
				   (lambda ()
				     (yas/minor-mode nil)
				     (set (make-local-variable 'compile-command)
					  "ant -find build.xml -q -e -Dlint.skip=true -Dskip.lint=true all && growlnotify -n Emacs -a Emacs -m 'JS Built'")))
			 (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
                         ))
         (:name bm
                :type http
                :url "https://raw.github.com/joodland/bm/master/bm.el"
                :after (progn
                         (require 'bm)
                         (global-set-key (kbd "<C-f2>") 'bm-toggle)
                         (global-set-key (kbd "<f2>")   'bm-next)
                         (global-set-key (kbd "<S-f2>") 'bm-previous)

                         (global-set-key (kbd "<left-fringe> <wheel-down>") 'bm-next-mouse)
                         (global-set-key (kbd "<left-fringe> <wheel-up>") 'bm-previous-mouse)
                         (global-set-key (kbd "<left-fringe> <mouse-1>") 'bm-toggle-mouse)
                         ))

	 (:name visible-mark
		:type http
		:url "http://www.emacswiki.org/emacs/download/visible-mark.el"
		:after (progn
			 (require 'visible-mark)
			 (global-visible-mark-mode t)))
	 (:name flymake-python
		:type git
		:url "http://github.com/akaihola/flymake-python.git"
		)
	 ))

(setq my-packages
      (append
       '(yaml-mode
         dired-details
         virtualenv
         ;;folding
         ;;python
         git-modeline
         ;;google-contacts
         ;;google-maps
         grep+
         growl
         header-button
         highlight-parentheses
         magithub
         markdown-mode
         pg
         ;;profile-dotemacs
         shell-current-directory
         ssh-config
         sudo-save
         ;;virtualenv
	 scratch
	 paredit
	 ;; python-mode
	 ;; ipython
	 python-pep8
	 rainbow-mode
 	 yasnippet
         textile-mode
         edit-server
	 )
       (mapcar 'el-get-source-name el-get-sources)))

(el-get 'nil my-packages)

(customize-set-variable
  'display-buffer-alist '(("\*Python.*" . (display-buffer-pop-up-window . nil))))

;;;We should have all the packages installed now

;;load up our settings for core emacs
(require 'aaditya-settings nil t)
(require 'aaditya-packages nil t)
(require 'aaditya-shell nil t)

;;(insert "\n(set-default-font \"" (cdr (assoc 'font (frame-parameters))) "\")\n")
(set-default-font "-apple-Everson Mono-medium-normal-normal-*-12-*-*-*-m-0-iso10646-1")


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-auto-start 4)
 '(ac-delay 1.2)
 '(ack-and-a-half-arguments (quote ("--nopager")))
 '(ack-and-a-half-prompt-for-directory t)
 '(ansi-color-names-vector [solarized-bg red green yellow blue magenta cyan solarized-fg])
 '(compilation-auto-jump-to-first-error t)
 '(compilation-context-lines 2)
 '(compilation-scroll-output t)
 '(compilation-window-height nil)
 '(cursor-color "#5c5cff")
 '(custom-safe-themes (quote ("501caa208affa1145ccbb4b74b6cd66c3091e41c5bb66c677feda9def5eab19c" "54d1bcf3fcf758af4812f98eb53b5d767f897442753e1aa468cfeb221f8734f9" "baed08a10ff9393ce578c3ea3e8fd4f8c86e595463a882c55f3bd617df7e5a45" "374e79a81930979e673b8e0869e135fb2450b18c6474ca145f104e0c6f003267" "e254937cba0f82c2d9eb3189a60748df9e486522" "1440d751f5ef51f9245f8910113daee99848e2c0" "485737acc3bedc0318a567f1c0f5e7ed2dfde3fb" "691f3cecbb3a1fe305caee6237750a8ce0f3567d" "5600dc0bb4a2b72a613175da54edb4ad770105aa" "0174d99a8f1fdc506fa54403317072982656f127" default)))
 '(default-frame-alist (quote ((vertical-scroll-bars . right) (left . 40) (top . 20) (width . 195) (height . 53) (font . "-apple-Everson Mono-medium-normal-normal-*-12-*-*-*-m-0-iso10646-1"))))
 '(dired-use-ls-dired nil)
 '(display-battery-mode t)
 '(ecb-auto-expand-tag-tree (quote all))
 '(ecb-auto-expand-tag-tree-collapse-other (quote only-if-on-tag))
 '(ecb-auto-update-methods-after-save t)
 '(ecb-compilation-buffer-names (quote (("*Calculator*") ("*vc*") ("*vc-diff*") ("*Apropos*") ("*Occur*") ("*shell*") ("\\*[cC]ompilation.*\\*" . t) ("\\*i?grep.*\\*" . t) ("*JDEE Compile Server*") ("*Help*") ("*Completions*") ("*Backtrace*") ("*Compile-log*") ("*bsh*") ("*Messages*") ("*eshell*"))))
 '(ecb-compile-window-height 0.25)
 '(ecb-compile-window-temporally-enlarge (quote both))
 '(ecb-layout-name "left11")
 '(ecb-layout-window-sizes (quote (("left11" (ecb-methods-buffer-name 0.22033898305084745 . 0.7424242424242424) (ecb-history-buffer-name 0.22033898305084745 . 0.24242424242424243)) ("left6" (ecb-sources-buffer-name 0.2028985507246377 . 0.1935483870967742) (ecb-methods-buffer-name 0.2028985507246377 . 0.5806451612903226) (ecb-history-buffer-name 0.2028985507246377 . 0.20967741935483872)) ("leftright1" (ecb-directories-buffer-name 0.1906779661016949 . 0.36363636363636365) (ecb-sources-buffer-name 0.1906779661016949 . 0.3333333333333333) (ecb-history-buffer-name 0.1906779661016949 . 0.2878787878787879) (ecb-methods-buffer-name 0.11864406779661017 . 0.9848484848484849)) ("leftright-analyse" (ecb-directories-buffer-name 0.2094017094017094 . 0.39705882352941174) (ecb-sources-buffer-name 0.2094017094017094 . 0.29411764705882354) (ecb-history-buffer-name 0.2094017094017094 . 0.29411764705882354) (ecb-methods-buffer-name 0.2264957264957265 . 0.47058823529411764) (ecb-analyse-buffer-name 0.2264957264957265 . 0.5147058823529411)))))
 '(ecb-methods-nodes-expand-spec (quote all))
 '(ecb-methods-show-node-info (quote (if-too-long . name)))
 '(ecb-options-version "2.40")
 '(ecb-primary-secondary-mouse-buttons (quote mouse-1--mouse-2))
 '(ecb-source-file-regexps (quote ((".*" ("\\(^\\(\\.\\|#\\)\\|\\(~$\\|\\.\\(elc\\|obj\\|o\\|class\\|lib\\|dll\\|a\\|so\\|cache\\|pyc\\)$\\)\\)") ("^\\.\\(emacs\\|gnus\\)$")))))
 '(ecb-source-path (quote (("/Users/aaditya/work/meghdoot" "meghdoot") ("/Users/aaditya/work/id" "epsilon-rp") ("/Users/aaditya/work/id/vaitarna/vaitarna" "vaitarna-rp") ("/" "/"))))
 '(ecb-tree-indent 4)
 '(ecb-truncate-long-names nil)
 '(ediff-window-setup-function (quote ediff-setup-windows-plain))
 '(eshell-cmpl-autolist t)
 '(eshell-cmpl-cycle-completions t)
 '(eshell-cmpl-expand-before-complete t)
 '(eshell-cmpl-ignore-case t)
 '(eshell-modules-list (quote (eshell-alias eshell-banner eshell-basic eshell-cmpl eshell-dirs eshell-glob eshell-hist eshell-ls eshell-pred eshell-prompt eshell-rebind eshell-script eshell-smart eshell-term eshell-unix eshell-xtra)))
 '(flymake-allowed-file-name-masks (quote (("\\.c\\'" flymake-simple-make-init) ("\\.cpp\\'" flymake-simple-make-init) ("\\.xml\\'" flymake-xml-init) ("\\.cs\\'" flymake-simple-make-init) ("\\.p[ml]\\'" flymake-perl-init) ("\\.php[345]?\\'" flymake-php-init) ("\\.h\\'" flymake-master-make-header-init flymake-master-cleanup) ("\\.java\\'" flymake-simple-make-java-init flymake-simple-java-cleanup) ("[0-9]+\\.tex\\'" flymake-master-tex-init flymake-master-cleanup) ("\\.tex\\'" flymake-simple-tex-init) ("\\.idl\\'" flymake-simple-make-init))))
 '(flymake-log-level 1)
 '(flymake-no-changes-timeout 8.0)
 '(font-latex-fontify-sectioning 1.2)
 '(frame-background-mode (quote dark))
 '(fringe-mode (quote (4 . 4)) nil (fringe))
 '(global-semantic-idle-breadcrumbs-mode t nil (semantic/idle))
 '(global-semantic-idle-local-symbol-highlight-mode t nil (semantic/idle))
 '(ido-decorations (quote ("{ " " }" " | " " | ..." "[ " " ]" " [No match]" " [Matched]" " [Not readable]" " [Too big]" " [Confirm]")))
 '(ido-enable-flex-matching t)
 '(ido-enable-regexp t)
 '(ido-enable-tramp-completion nil)
 '(ido-ubiquitous-mode t)
 '(ido-use-virtual-buffers t)
 '(indicate-buffer-boundaries nil)
 '(initial-frame-alist (quote ((vertical-scroll-bars . right) (left . 40) (top . 20) (width . 195) (height . 56) (font . "-apple-Everson Mono-medium-normal-normal-*-12-*-*-*-m-0-iso10646-1"))))
 '(js2-basic-offset 2)
 '(js2-cleanup-whitespace t)
 '(js2-global-externs (quote (Y epsilon)))
 '(js2-highlight-level 2)
 '(js2-mirror-mode t)
 '(js2-mode-indent-ignore-first-tab t)
 '(magit-status-buffer-switch-function (quote switch-to-buffer))
 '(midnight-mode t nil (midnight))
 '(ns-right-alternate-modifier (quote control))
 '(remote-file-name-inhibit-cache 60)
 '(safe-local-variable-values (quote ((encoding . utf-8))))
 '(semantic-complete-inline-analyzer-displayor-class (quote semantic-displayor-tooltip))
 '(semantic-default-submodes (quote (global-semantic-decoration-mode global-semantic-idle-scheduler-mode global-semanticdb-minor-mode)))
 '(semantic-python-dependency-system-include-path (quote ("/Users/aaditya/work/meghdoot/src/py" "/Users/aaditya/work/id" " /Users/aaditya/work/id/src" " /Users/aaditya/work/id/src/id/vaitarna")))
 '(semanticdb-project-roots (quote ("/Users/aaditya/work/id" "/Users/aaditya/work/meghdoot" "/Users/aaditya")))
 '(show-paren-mode t)
 '(size-indication-mode t)
 '(sql-database "epsilon_test")
 '(tool-bar-mode nil)
 '(uniquify-buffer-name-style (quote post-forward-angle-brackets) nil (uniquify))
 '(uniquify-min-dir-content 1)
 '(uniquify-separator "|")
 '(uniquify-strip-common-suffix nil)
 '(uniquify-trailing-separator-p t)
 '(vc-handled-backends (quote (git)))
 '(virtualenv-workon-starts-python nil)
 '(visible-bell t)
 '(windmove-wrap-around t)
 '(window-combination-limit t)
 '(window-combination-resize t)
 '(window-sides-vertical t))

(toggle-debug-on-error nil)

(cd "work")
;; (add-hook 'eshell-mode-hook ;; for some reason this needs to be a hook
;;           '(lambda ()
;;              (set-face-attribute 'eshell-prompt nil :foreground "red")
;;              ))
(eshell)

;; (set-face-attribute 'eshell-prompt nil :foreground "red")

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#002b36" :foreground "#A3B4B6" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 130 :width normal :foundry "apple" :family "Menlo"))))
 '(diredp-compressed-file-suffix ((t nil)) t)
 '(diredp-ignored-file-name ((t nil)) t)
 '(diredp-write-priv ((t nil)) t)
 '(ecb-default-general-face ((t (:slant normal :height 120 :family "Aller Light"))))
 '(eshell-prompt ((t (:slant italic :weight bold))))
 '(font-latex-sectioning-1-face ((t (:inherit font-latex-sectioning-2-face :height 1.0))) t)
 '(font-latex-sectioning-2-face ((t (:inherit font-latex-sectioning-3-face :height 1.05))) t)
 '(font-latex-sectioning-3-face ((t (:inherit font-latex-sectioning-4-face :height 1.1))) t)
 '(font-lock-comment-face ((t (:foreground "#73d216" :slant normal :height 110 :family "Bitstream Vera Sans"))))
 '(fringe ((t (:background "dark slate gray"))))
 '(ido-virtual ((t (:inherit font-lock-builtin-face :slant italic))))
 '(js2-warning-face ((t (:underline "orange" :weight bold))))
 '(py-XXX-tag-face ((t (:inherit font-lock-string-face :underline t :weight bold))) t)
 '(semantic-decoration-on-unknown-includes ((t nil)))
 '(semantic-tag-boundary-face ((t (:overline "gray"))))
 '(variable-pitch ((t (:height 140 :family "Candara"))))
 '(visible-mark-face ((t (:inverse-video t)))))
