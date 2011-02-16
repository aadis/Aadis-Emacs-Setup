;;setup some initial load paths
(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(add-to-list 'load-path "~/.emacs.d/color-theme-6.6.0")

;;our package sources
(setq package-archives (quote (("gnu" . "http://elpa.gnu.org/packages/")
			       ("elpa" . "http://tromey.com/elpa/"))))
(require 'package)
(package-initialize)
(require 'el-get)

;;all the packages we want to setup
(setq el-get-sources
      '(
	(:name yaml-mode)
	(:name rainbow-mode)
	(:name asciidoc)
	(:name geiser
               :after (lambda () 
                        (require 'geiser-install)))
	(:name ecb
	       :after ((lambda () 
                         (require 'semantic)
                         ;;(global-ede-mode 1)
                         (setq semantic-load-turn-everything-on t)
                         (semantic-mode 1)
                         (require 'cedet)
                         (require 'ecb))))
	(:name js2-mode
	       :after (lambda ()
                        (require 'js2-mode)
                        (setq  js2-basic-offset 4
                               js2-highlight-level 3
                               js2-indent-on-enter-key t)
                        (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))))
	;;(:name el-get)
        (:name magit
	       :after (lambda ()
                        (require 'magit)
                        (global-set-key (kbd "C-x g") 'magit-status)))
        (:name smex
	       :after (lambda () 
                        (require 'smex)
                        (smex-initialize)
                        (global-set-key (kbd "M-x") 'smex)
                        (global-set-key (kbd "M-X") 'smex-major-mode-commands)
                        ;; This is your old M-x.
                        (global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)))
        (:name ectags
               :type git
               :url "git://repo.or.cz/ectags.git")
        (:name egg)
        (:name regex-tool)
	(:name yasnippet)
        (:name python-pep8
               :type git
               :url "git://gist.github.com/303273.git")
        (:name flymake-python
               :type git
               :url "http://github.com/akaihola/flymake-python.git")
        (:name python-pylint
               :type git
               :url "git://gist.github.com/302848.git")
        (:name visible-mark
               :type http
               :url "http://www.emacswiki.org/emacs/download/visible-mark.el"
	       :after (lambda () (global-visible-mark-mode t)))
        (:name python-mode)
        (:name pymacs)
        (:name ropemacs)
        (:name ipython)
        ;; (:name apel)
        (:name session
	       :after (lambda () 
                        (require 'session)
                        (add-hook 'after-init-hook 'session-initialize)))
        (:name mysql
               :type http
               :url "http://www.emacswiki.org/emacs/download/mysql.el")
        (:name sql-completion
               :type http
               :url "http://www.emacswiki.org/emacs/download/sql-completion.el"
	       :after (lambda ()
                        (require 'sql-completion)
                        (setq sql-interactive-mode-hook
                              (lambda ()
                                (define-key sql-interactive-mode-map "\t" 'comint-dynamic-complete)
                                (toggle-truncate-lines)
                                (sql-mysql-completion-init)))))
        (:name moz
               :type http
               :url "http://github.com/bard/mozrepl/raw/master/chrome/content/moz.el"
	       :after (lambda ()
                        (autoload 'moz-minor-mode "moz" "Mozilla Minor and Inferior Mozilla Modes" t)
                        (defun js2-custom-setup ()
                          (moz-minor-mode 1))
                        (add-hook 'js2-mode-hook 'js2-custom-setup)))
        (:name sml-modeline
	       :after (lambda ()
                        (require 'sml-modeline nil t)    ;; use sml-modeline if available
                        (sml-modeline-mode 1)))
        (:name scratch)
        (:name pylookup)
        ;;(:name auctex)
        )
      )

(el-get 'sync)

(setq semantic-python-dependency-system-include-path
      '("/Users/aaditya/work/id" "/Users/aaditya/work/id/src" "/Users/aaditya/work/id/src/id/vaitarna" "/Users/aaditya/.env/ep/lib/python2.6/site-packages" "/Users/aaditya/.env/ep/lib/python2.6" "/System/Library/Frameworks/Python.framework/Versions/2.6/lib/python2.6"))


;; (setq load-path (cons (expand-file-name "~/src/local/gnus/lisp") load-path))
;; (require 'gnus-load)
(require 'info)
(add-to-list 'Info-default-directory-list (expand-file-name "~/src/local/gnus/texi"))

(require 'aaditya-settings)
(require 'aaditya-packages)
(require 'aaditya-python)

(when (fboundp 'aaditya/set-screen)
  (aaditya/set-screen))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-newline-function (quote newline-and-indent))
 '(custom-enabled-themes (quote (tango-dark)))
 '(ecb-eshell-auto-activate t)
 '(ecb-key-map (quote ("C-z" (t "fh" ecb-history-filter) (t "fs" ecb-sources-filter) (t "fm" ecb-methods-filter) (t "fr" ecb-methods-filter-regexp) (t "ft" ecb-methods-filter-tagclass) (t "fc" ecb-methods-filter-current-type) (t "fp" ecb-methods-filter-protection) (t "fn" ecb-methods-filter-nofilter) (t "fl" ecb-methods-filter-delete-last) (t "ff" ecb-methods-filter-function) (t "p" ecb-nav-goto-previous) (t "n" ecb-nav-goto-next) (t "lc" ecb-change-layout) (t "lr" ecb-redraw-layout) (t "lw" ecb-toggle-ecb-windows) (t "lt" ecb-toggle-layout) (t "s" ecb-window-sync) (t "r" ecb-rebuild-methods-buffer) (t "a" ecb-toggle-auto-expand-tag-tree) (t "x" ecb-expand-methods-nodes) (t "h" ecb-show-help) (t "gl" ecb-goto-window-edit-last) (t "g1" ecb-goto-window-edit1) (t "g2" ecb-goto-window-edit2) (t "gc" ecb-goto-window-compilation) (t "gd" ecb-goto-window-directories) (t "gs" ecb-goto-window-sources) (t "gm" ecb-goto-window-methods) (t "gh" ecb-goto-window-history) (t "ga" ecb-goto-window-analyse) (t "gb" ecb-goto-window-speedbar) (t "md" ecb-maximize-window-directories) (t "ms" ecb-maximize-window-sources) (t "mm" ecb-maximize-window-methods) (t "mh" ecb-maximize-window-history) (t "ma" ecb-maximize-window-analyse) (t "mb" ecb-maximize-window-speedbar) (t "e" eshell) (t "o" ecb-toggle-scroll-other-window-scrolls-compile) (t "\\" ecb-toggle-compile-window) (t "/" ecb-toggle-compile-window-height) (t "," ecb-cycle-maximized-ecb-buffers) (t "." ecb-cycle-through-compilation-buffers))))
 '(ecb-layout-name "leftright1")
 '(ecb-layout-window-sizes (quote (("leftright1" (ecb-directories-buffer-name 0.1452991452991453 . 0.39436619718309857) (ecb-sources-buffer-name 0.1452991452991453 . 0.29577464788732394) (ecb-history-buffer-name 0.1452991452991453 . 0.29577464788732394) (ecb-methods-buffer-name 0.1282051282051282 . 0.9859154929577465)))))
 '(ecb-methods-menu-sorter (lambda (entries) (let ((sorted (copy-list entries))) (sort sorted (quote string-lessp)))))
 '(ecb-options-version "2.40")
 '(ecb-primary-secondary-mouse-buttons (quote mouse-1--mouse-2))
 '(ecb-source-file-regexps (quote ((".*" ("\\(^\\(\\.\\|#\\)\\|\\(~$\\|\\.\\(elc\\|obj\\|o\\|class\\|lib\\|dll\\|a\\|so\\|cache\\|pyc\\)$\\)\\)") ("^\\.\\(emacs\\|gnus\\)$")))))
 '(ecb-source-path (quote (("/Users/aaditya/work/id/src/id/vaitarna" "vaitarna") ("/Users/aaditya/work/id" "id") ("/Users/aaditya/work/id/src/id/vaitarna/vaitarna/templates" "templates") ("/Users/aaditya/work/id/src/id/vaitarna/vaitarna/public/js" "js") ("/Users/aaditya/work/id/src/id/vaitarna/vaitarna/public/css" "css") ("/Users/aaditya/work/id/src/id/vaitarna/vaitarna/controllers" "controllers") ("/" "/"))))
 '(egg-enable-tooltip t)
 '(elscreen-display-screen-number nil)
 '(elscreen-tab-display-control nil)
 '(elscreen-tab-display-kill-screen (quote right))
 '(eshell-modules-list (quote (eshell-alias eshell-banner eshell-basic eshell-cmpl eshell-dirs eshell-glob eshell-hist eshell-ls eshell-pred eshell-prompt eshell-rebind eshell-script eshell-smart eshell-term eshell-unix eshell-xtra)))
 '(geiser-racket-binary "/Users/aaditya/Applications/Racket v5.1/bin/racket")
 '(ido-default-file-method (quote selected-window))
 '(ido-enable-regexp t)
 '(ipython-command "/Users/aaditya/work/id/vaitarna/pylons-shell")
 '(ns-function-modifier (quote hyper))
 '(ns-pop-up-frames nil)
 '(regex-tool-backend (quote perl))
 '(show-paren-mode t)
 '(show-paren-style (quote expression))
 '(size-indication-mode t)
 '(tabbar-separator (quote ("\"                             \"")))
 '(tool-bar-mode nil)
 '(transient-mark-mode nil)
 '(uniquify-buffer-name-style (quote post-forward-angle-brackets) nil (uniquify))
 '(uniquify-separator " | ")
 '(uniquify-trailing-separator-p t)
 '(visible-bell t))

(toggle-debug-on-error nil)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:stipple nil :background "#000" :foreground "white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "apple" :family "Consolas"))))
 '(elscreen-tab-background-face ((t (:background "black" :weight bold :height 1.6))))
 '(elscreen-tab-current-screen-face ((t (:background "LightGoldenrod1" :foreground "black" :weight normal :height 1.1 :family "Geneva"))))
 '(elscreen-tab-other-screen-face ((t (:background "gray95" :foreground "black" :underline nil :height 1.1 :family "Geneva"))))
 '(ido-first-match ((t (:foreground "gold" :inverse-video nil :weight normal))))
 '(magit-diff-add ((t (:foreground "green"))))
 '(magit-item-highlight ((t (:background "gray20"))))
 '(match ((t (:background "#0E2852"))))
 '(mumamo-background-chunk-major ((t nil)))
 '(mumamo-background-chunk-submode1 ((t nil)))
 '(mumamo-background-chunk-submode2 ((t (:background "gray20"))))
 '(show-paren-match ((t (:background "#0D2B59"))))
 '(visible-mark-face ((t (:inverse-video t)))))
