(setq message-log-max 2000)

;;load up ido first, need it pretty much always
(require 'ido)
(setq ido-everywhere t)
(setq ido-default-buffer-method 'selected-window)
(ido-mode 1)

;;setup some initial load paths
(add-to-list 'load-path "~/.emacs.d/")


;;our package sources
(setq package-archives (quote (("gnu" . "http://elpa.gnu.org/packages/")
                               ("marmalade" . "http://marmalade-repo.org/packages/")
			       ("elpa" . "http://tromey.com/elpa/"))))
(require 'package)
(package-initialize)

;;we're now going to be using el-get to install packages we want
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil t)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (end-of-buffer)
    (eval-print-last-sexp)))

(setq el-get-sources
      '(
        (:name ecb
               :after (lambda ()
                        (setq stack-trace-on-error t)
                        (require 'ecb)))
        (:name magit
		:after (lambda ()
			 (require 'magit)
			 (global-set-key (kbd "C-x g") 'magit-status)))
	 (:name pymacs
		:after (lambda () 
			 (setq pymacs-python-command (expand-file-name "~/.env/ep/bin/python"))
			 (require 'pymacs)))
	 (:name ropemacs
		:after (lambda ()
                         (pymacs-load "ropemacs" "rope-")
			 (setq ropemacs-confirm-saving nil
			       ropemacs-guess-project t
			       ropemacs-enable-autoimport t)))
	 (:name smex
		:after (lambda () 
			 (require 'smex)
			 (smex-initialize)
			 (global-set-key (kbd "M-x") 'smex)
			 (global-set-key (kbd "M-X") 'smex-major-mode-commands)
			 ;; This is your old M-x.
			 (global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)))
	 (:name sml-modeline
		:after (lambda ()
			 (require 'sml-modeline nil t)    ;; use sml-modeline if available
			 (sml-modeline-mode 1)))
	 (:name js2-mode
		:after (lambda ()
			 (require 'js2-mode)
			 (setq  js2-basic-offset 4
				js2-highlight-level 2
				js2-indent-on-enter-key t)
			 (add-hook 'js2-mode-hook
				   (lambda ()
				     (yas/minor-mode t)
				     (set (make-local-variable 'compile-command)
					  "ant -find build.xml -q -e -Dlint.skip=true -Dskip.lint=true all")))
			 ;;(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
                         ))
	 (:name visible-mark
		:type http
		:url "http://www.emacswiki.org/emacs/download/visible-mark.el"
		:after (lambda () 
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
         ant
         command-frequency
         dired-details
         folding
         git-blame
         python
         git-modeline
         google-contacts
         google-maps
         grep+
         growl
         header-button
         highlight-parentheses
         magithub
         markdown-mode
         org-mode
         org-fstree
         org-buffers
         pg
         profile-dotemacs
         pylookup
         shell-current-directory
         sicp
         ssh-config
         sudo-save
         virtualenv
	 scratch
	 paredit
	 python-mode
	 ipython
	 python-pep8
	 rainbow-mode
 	 yasnippet
	 )
       (mapcar 'el-get-source-name el-get-sources)))

(el-get 'sync my-packages)

;;;We should have all the packages installed now

;;load up our settings for core emacs
(require 'aaditya-settings nil t)
(require 'aaditya-packages nil t)
(require 'aaditya-shell nil t)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-auto-start 4)
 '(ac-delay 1.2)
 '(bidi-paragraph-direction (quote left-to-right))
 '(compilation-auto-jump-to-first-error t)
 '(compilation-context-lines 2)
 '(compilation-scroll-output t)
 '(compilation-window-height 12)
 '(cursor-color "#5c5cff")
 '(custom-enabled-themes nil)
 '(custom-safe-themes (quote ("691f3cecbb3a1fe305caee6237750a8ce0f3567d" "5600dc0bb4a2b72a613175da54edb4ad770105aa" "0174d99a8f1fdc506fa54403317072982656f127" default)))
 '(display-battery-mode t)
 '(ecb-layout-name "leftright1")
 '(ecb-layout-window-sizes (quote (("leftright1" (ecb-directories-buffer-name 0.16666666666666666 . 0.38235294117647056) (ecb-sources-buffer-name 0.16666666666666666 . 0.29411764705882354) (ecb-history-buffer-name 0.16666666666666666 . 0.3088235294117647) (ecb-methods-buffer-name 0.19658119658119658 . 0.9852941176470589)) ("leftright-analyse" (ecb-directories-buffer-name 0.2094017094017094 . 0.39705882352941174) (ecb-sources-buffer-name 0.2094017094017094 . 0.29411764705882354) (ecb-history-buffer-name 0.2094017094017094 . 0.29411764705882354) (ecb-methods-buffer-name 0.2264957264957265 . 0.47058823529411764) (ecb-analyse-buffer-name 0.2264957264957265 . 0.5147058823529411)))))
 '(ecb-options-version "2.40")
 '(ecb-primary-secondary-mouse-buttons (quote mouse-1--mouse-2))
 '(ecb-source-file-regexps (quote ((".*" ("\\(^\\(\\.\\|#\\)\\|\\(~$\\|\\.\\(elc\\|obj\\|o\\|class\\|lib\\|dll\\|a\\|so\\|cache\\|pyc\\)$\\)\\)") ("^\\.\\(emacs\\|gnus\\)$")))))
 '(ecb-source-path (quote (("/Users/aaditya/work/id" "Epsilon") ("/Users/aaditya/work/id/vaitarna/vaitarna" "vaitarna"))))
 '(ecb-tree-indent 2)
 '(ecb-vc-enable-support nil)
 '(eshell-modules-list (quote (eshell-alias eshell-banner eshell-basic eshell-cmpl eshell-dirs eshell-glob eshell-hist eshell-ls eshell-pred eshell-prompt eshell-rebind eshell-script eshell-smart eshell-term eshell-unix eshell-xtra)))
 '(flymake-allowed-file-name-masks (quote (("\\.c\\'" flymake-simple-make-init) ("\\.cpp\\'" flymake-simple-make-init) ("\\.xml\\'" flymake-xml-init) ("\\.cs\\'" flymake-simple-make-init) ("\\.p[ml]\\'" flymake-perl-init) ("\\.php[345]?\\'" flymake-php-init) ("\\.h\\'" flymake-master-make-header-init flymake-master-cleanup) ("\\.java\\'" flymake-simple-make-java-init flymake-simple-java-cleanup) ("[0-9]+\\.tex\\'" flymake-master-tex-init flymake-master-cleanup) ("\\.tex\\'" flymake-simple-tex-init) ("\\.idl\\'" flymake-simple-make-init))))
 '(flymake-log-level 1)
 '(flymake-no-changes-timeout 8.0)
 '(font-latex-fontify-sectioning 1.2)
 '(global-semantic-idle-breadcrumbs-mode t nil (semantic/idle))
 '(global-semantic-idle-local-symbol-highlight-mode t nil (semantic/idle))
 '(ido-use-virtual-buffers t)
 '(midnight-mode t nil (midnight))
 '(ns-right-alternate-modifier (quote control))
 '(semantic-default-submodes (quote (global-semantic-highlight-func-mode global-semantic-decoration-mode global-semantic-stickyfunc-mode global-semantic-idle-scheduler-mode global-semanticdb-minor-mode global-semantic-idle-summary-mode global-semantic-mru-bookmark-mode)))
 '(semantic-mode t)
 '(semantic-python-dependency-system-include-path (quote ("/Users/aaditya/work/id" " /Users/aaditya/work/id/src" " /Users/aaditya/work/id/src/id/vaitarna")))
 '(semanticdb-project-roots (quote ("/Users/aaditya/work/id")))
 '(show-paren-mode t)
 '(size-indication-mode t)
 '(uniquify-buffer-name-style (quote forward) nil (uniquify))
 '(uniquify-min-dir-content 1)
 '(uniquify-separator "|")
 '(visible-bell t))

(toggle-debug-on-error nil)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "oldlace" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 130 :width normal :foundry "apple" :family "Consolas"))))
 '(cursor ((t (:background "indian red"))))
 '(diredp-compressed-file-suffix ((t nil)))
 '(diredp-file-name ((t (:foreground "blue"))))
 '(diredp-ignored-file-name ((t nil)))
 '(diredp-write-priv ((t nil)))
 '(flymake-errline ((t (:background "plum2"))))
 '(font-lock-comment-face ((t (:foreground "Firebrick" :slant oblique :height 1.0 :family "Consolas"))))
 '(header-line ((t (:inherit mode-line :background "orange1" :foreground "#000" :box nil))))
 '(semantic-tag-boundary-face ((t (:overline "gray")))))

(put 'ido-exit-minibuffer 'disabled nil)
