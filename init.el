(setq message-log-max 500)

;;setup some initial load paths
(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(add-to-list 'load-path "~/.emacs.d/el-get/ecb/ecb2")
(add-to-list 'load-path "~/.emacs.d/el-get/ecb/cedet/semantic")
(add-to-list 'load-path "~/.emacs.d/el-get/color-theme")

;;our package sources
(setq package-archives (quote (("gnu" . "http://elpa.gnu.org/packages/")
                               ("marmalade" . "http://marmalade-repo.org/packages/")
			       ("elpa" . "http://tromey.com/elpa/"))))
(require 'package)
(package-initialize)
(require 'el-get)

;;ECB still depends on this
(setq stack-trace-on-error nil)

;;use solarized color theme
;; (require 'color-theme)
;; (when (require 'color-theme-sanityinc-solarized)
;;   (color-theme-sanityinc-solarized-light))

;;use built in theme system
(require 'solarized-light-theme)


;;all the packages we want to setup
(setq el-get-sources
      '(
        (:name bbdb)
	(:name yaml-mode)
	(:name color-theme)
	(:name rainbow-mode)
        (:name python
               :after (lambda () (require 'python)
                        (setq python-shell-interpreter "ipython"
                              python-shell-interpreter-args ""
                              python-shell-prompt-regexp "In \[[0-9]+\]: "
                              python-shell-prompt-output-regexp "Out\[[0-9]+\]: "
                              python-shell-completion-setup-code ""
                              python-shell-completion-string-code "';  '.join(__IP.complete('''%s'''))\n")))
        (:name pymacs
               :after (lambda () 
                        (setq pymacs-python-command (expand-file-name "~/.env/ep/bin/python"))
                        (require 'pymacs)))
        (:name ropemacs
               :after (lambda () 
                        (setq ropemacs-confirm-saving nil
                              ropemacs-guess-project t
                              ropemacs-enable-autoimport t)))
        (:name pylookup
               :after (lambda ()
                        (setq pylookup-dir "/Users/aaditya/Documents")
                        (setq pylookup-db-file (concat pylookup-dir "/pylookup.db"))
                        ;;(setq pylookup-program "/Users/aaditya/src/bin/pylookup.py")
                        (setq py-python-command "python")
                        (require 'pylookup)
                        (autoload 'pylookup-lookup "pylookup"
                          "Lookup SEARCH-TERM in the Python HTML indexes." t)
                        (autoload 'pylookup-update "pylookup"
                          "Run pylookup-update and create the database at `pylookup-db-file'." t)
                        (global-set-key "\C-ch" 'pylookup-lookup)))
        (:name scratch)
        ;;(:name auctex)
        ;;(:name paredit)
        ;;(:name quack)
	;; (:name geiser
        ;;        :after (lambda () 
        ;;                 (require 'geiser-install)
        ;;                 (require 'quack)
        ;;                 (require 'paredit)))
	(:name ecb
	       :after ((lambda ()
                         (require 'semantic)
                         ;;(global-ede-mode 1)
                         (setq semantic-load-turn-everything-on t)
                         (semantic-mode 1)
                         (global-semanticdb-minor-mode 1)
                         (global-semantic-stickyfunc-mode 1)
                         (global-semantic-highlight-func-mode 1)
                         (require 'cedet)
                         (load "~/.emacs.d/el-get/ecb/ecb.el")
                         (require 'ecb))))
	(:name js2-mode
	       :after (lambda ()
                        (require 'js2-mode)
                        (setq  js2-basic-offset 4
                               js2-highlight-level 3
                               js2-indent-on-enter-key t)
                        (add-hook 'js2-mode-hook
                                  (lambda ()
                                    (set (make-local-variable 'compile-command)
                                         "ant -find build.xml -q -e -Dlint.skip=true -Dskip.lint=true all && growlnotify -m \"Epsilon built\" -n Emacs -i js")))
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
        (:name sml-modeline
	       :after (lambda ()
                        (require 'sml-modeline nil t)    ;; use sml-modeline if available
                        (sml-modeline-mode 1)))
        (:name session
	       :after (lambda () 
                        (require 'session)
                        (add-hook 'after-init-hook 'session-initialize)))
        ;; (:name ectags
        ;;        :type git
        ;;        :url "git://repo.or.cz/ectags.git")
        (:name python-pep8
               :type git
               :url "git://gist.github.com/303273.git"
               :after (lambda () (autoload 'pep8 "python-pep8")))
        (:name flymake-python
               :type git
               :url "http://github.com/akaihola/flymake-python.git")
        (:name python-pylint
               :type git
               :url "git://gist.github.com/302848.git"
               :after (lambda () 
                        (autoload 'python-pylint "python-pylint")
                        (autoload 'pylint "python-pylint")))
        (:name visible-mark
               :type http
               :url "http://www.emacswiki.org/emacs/download/visible-mark.el"
	       :after (lambda () 
                        (require 'visible-mark)
                        (global-visible-mark-mode t)))
        (:name eproject
               :type git
               :url "https://github.com/jrockway/eproject.git")
        (:name moz
               :type http
               :url "http://github.com/bard/mozrepl/raw/master/chrome/content/moz.el"
	       :after (lambda ()
                        (autoload 'moz-minor-mode "moz" "Mozilla Minor and Inferior Mozilla Modes" t)
                        (defun js2-custom-setup ()
                          (moz-minor-mode 1))
                        (add-hook 'js2-mode-hook 'js2-custom-setup)))
	(:name yasnippet)
        )
      )

(el-get)

(setq semantic-python-dependency-system-include-path
      '("/Users/aaditya/work/id" "/Users/aaditya/work/id/src" "/Users/aaditya/work/id/src/id/vaitarna" "/Users/aaditya/.env/ep/lib/python2.6/site-packages" "/Users/aaditya/.env/ep/lib/python2.6" "/System/Library/Frameworks/Python.framework/Versions/2.6/lib/python2.6"))


(setq load-path (cons (expand-file-name "~/src/local/gnus/lisp") load-path))
(require 'gnus-load)

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
 '(ansi-color-names-vector ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(bbdb-display-layout-alist (quote ((one-line (order phones mail-alias net notes) (name-end . 50) (toggle . t)) (multi-line (omit creation-date timestamp) (toggle . t)) (pop-up-multi-line) (full-multi-line))))
 '(bbdb-pop-up-target-columns 25)
 '(bbdb-pop-up-target-lines 7)
 '(compilation-window-height 20)
 '(custom-safe-themes (quote ("440039bfdb4b34cc700a88690c1a5e5a70db30d8" default)))
 '(ecb-compile-window-height 8)
 '(ecb-compile-window-prevent-shrink-below-height nil)
 '(ecb-compile-window-temporally-enlarge (quote both))
 '(ecb-compile-window-width (quote edit-window))
 '(ecb-eshell-auto-activate t)
 '(ecb-key-map (quote ("C-z" (t "fh" ecb-history-filter) (t "fs" ecb-sources-filter) (t "fm" ecb-methods-filter) (t "fr" ecb-methods-filter-regexp) (t "ft" ecb-methods-filter-tagclass) (t "fc" ecb-methods-filter-current-type) (t "fp" ecb-methods-filter-protection) (t "fn" ecb-methods-filter-nofilter) (t "fl" ecb-methods-filter-delete-last) (t "ff" ecb-methods-filter-function) (t "p" ecb-nav-goto-previous) (t "n" ecb-nav-goto-next) (t "lc" ecb-change-layout) (t "lr" ecb-redraw-layout) (t "lw" ecb-toggle-ecb-windows) (t "lt" ecb-toggle-layout) (t "s" ecb-window-sync) (t "r" ecb-rebuild-methods-buffer) (t "a" ecb-toggle-auto-expand-tag-tree) (t "x" ecb-expand-methods-nodes) (t "h" ecb-show-help) (t "gl" ecb-goto-window-edit-last) (t "g1" ecb-goto-window-edit1) (t "g2" ecb-goto-window-edit2) (t "gc" ecb-goto-window-compilation) (t "gd" ecb-goto-window-directories) (t "gs" ecb-goto-window-sources) (t "gm" ecb-goto-window-methods) (t "gh" ecb-goto-window-history) (t "ga" ecb-goto-window-analyse) (t "gb" ecb-goto-window-speedbar) (t "md" ecb-maximize-window-directories) (t "ms" ecb-maximize-window-sources) (t "mm" ecb-maximize-window-methods) (t "mh" ecb-maximize-window-history) (t "ma" ecb-maximize-window-analyse) (t "mb" ecb-maximize-window-speedbar) (t "e" eshell) (t "o" ecb-toggle-scroll-other-window-scrolls-compile) (t "\\" ecb-toggle-compile-window) (t "/" ecb-toggle-compile-window-height) (t "," ecb-cycle-maximized-ecb-buffers) (t "." ecb-cycle-through-compilation-buffers))))
 '(ecb-layout-always-operate-in-edit-window (quote (switch-to-buffer)))
 '(ecb-layout-name "aadityaright2")
 '(ecb-layout-window-sizes (quote (("aadityaright2" (ecb-methods-buffer-name 0.23504273504273504 . 0.4868421052631579) (ecb-history-buffer-name 0.23504273504273504 . 0.5)) ("aadityaright1" (ecb-methods-buffer-name 0.14957264957264957 . 0.4868421052631579) (ecb-history-buffer-name 0.14957264957264957 . 0.25) (ecb-speedbar-buffer-name 0.14957264957264957 . 0.25)) ("leftright1" (ecb-directories-buffer-name 0.1452991452991453 . 0.39436619718309857) (ecb-sources-buffer-name 0.1452991452991453 . 0.29577464788732394) (ecb-history-buffer-name 0.1452991452991453 . 0.29577464788732394) (ecb-methods-buffer-name 0.1282051282051282 . 0.9859154929577465)))))
 '(ecb-methods-menu-sorter (lambda (entries) (let ((sorted (copy-list entries))) (sort sorted (quote string-lessp)))))
 '(ecb-new-ecb-frame nil)
 '(ecb-options-version "2.40")
 '(ecb-primary-secondary-mouse-buttons (quote mouse-1--mouse-2))
 '(ecb-source-file-regexps (quote ((".*" ("\\(^\\(\\.\\|#\\)\\|\\(~$\\|\\.\\(elc\\|obj\\|o\\|class\\|lib\\|dll\\|a\\|so\\|cache\\|pyc\\)$\\)\\)") ("^\\.\\(emacs\\|gnus\\)$")))))
 '(ecb-source-path (quote (("/Users/aaditya/work/id/src/id/vaitarna" "vaitarna") ("/Users/aaditya/work/id" "id") ("/Users/aaditya/work/id/src/id/vaitarna/vaitarna/templates" "templates") ("/Users/aaditya/work/id/src/id/vaitarna/vaitarna/public/js" "js") ("/Users/aaditya/work/id/src/id/vaitarna/vaitarna/public/css" "css") ("/Users/aaditya/work/id/src/id/vaitarna/vaitarna/controllers" "controllers") ("/" "/") ("/Users/aaditya" "HOME"))))
 '(ecb-tree-indent 2)
 '(ecb-vc-enable-support nil)
 '(egg-enable-tooltip t)
 '(elscreen-display-screen-number nil)
 '(elscreen-tab-display-control nil)
 '(elscreen-tab-display-kill-screen (quote right))
 '(eproject-completing-read-function (quote eproject--ido-completing-read))
 '(eshell-modules-list (quote (eshell-alias eshell-banner eshell-basic eshell-cmpl eshell-dirs eshell-glob eshell-hist eshell-ls eshell-pred eshell-prompt eshell-rebind eshell-script eshell-smart eshell-term eshell-unix eshell-xtra)))
 '(geiser-racket-binary "/Users/aaditya/Applications/Racket v5.1/bin/racket")
 '(global-semantic-stickyfunc-mode t)
 '(global-semanticdb-minor-mode t)
 '(gnus-cache-enter-articles (quote (ticked dormant unread read)))
 '(gnus-use-cache t)
 '(ido-default-file-method (quote selected-window))
 '(ido-enable-regexp t)
 '(ipython-command "/Users/aaditya/work/id/vaitarna/pylons-shell")
 '(js2-auto-indent-p t)
 '(js2-bounce-indent-p nil)
 '(js2-cleanup-whitespace t)
 '(js2-dynamic-idle-timer-adjust 25000)
 '(js2-global-externs (quote ("Y" "YUI" "epsilon")))
 '(js2-highlight-level 3)
 '(markdown-italic-underscore t)
 '(mm-text-html-renderer (quote gnus-w3m))
 '(ns-function-modifier (quote hyper))
 '(ns-pop-up-frames nil)
 '(regex-tool-backend (quote perl))
 '(semantic-mode t)
 '(show-paren-mode t)
 '(show-paren-style (quote expression))
 '(size-indication-mode t)
 '(sql-connection-alist (quote (("epsilon_test" (sql-product (quote postgres)) (sql-user "epsilon") (sql-database "epsilon_test") (sql-server "")))))
 '(sql-product (quote postgres) t)
 '(tabbar-separator (quote ("\"                             \"")))
 '(tool-bar-mode nil)
 '(transient-mark-mode nil)
 '(uniquify-buffer-name-style (quote post-forward-angle-brackets) nil (uniquify))
 '(uniquify-separator " | ")
 '(uniquify-trailing-separator-p t)
 '(visible-bell t)
 '(yas/trigger-key "<C-tab>"))

(toggle-debug-on-error nil)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(elscreen-tab-background-face ((t (:background "black" :weight bold :height 1.6))) t)
 '(elscreen-tab-current-screen-face ((t (:background "LightGoldenrod1" :foreground "black" :weight normal :height 1.1 :family "Geneva"))) t)
 '(elscreen-tab-other-screen-face ((t (:background "gray95" :foreground "black" :underline nil :height 1.1 :family "Geneva"))) t)
 '(font-lock-comment-face ((t (:foreground "#708183" :slant italic :height 110 :family "menlo"))))
 '(gnus-header-content ((t (:inherit nil :box nil :weight bold))) t)
 '(header-line ((t (:inherit nil :background "lightblue" :foreground "black" :box (:line-width 1 :color "grey75" :style released-button))))))

(put 'ido-exit-minibuffer 'disabled nil)

;; (when (require 'color-theme-sanityinc-solarized)
;;   (color-theme-sanityinc-solarized-light))
