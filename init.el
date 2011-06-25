(setq message-log-max 2000)

;;setup some initial load paths
(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

;; (add-to-list 'load-path "~/.emacs.d/el-get/ecb/ecb2")
;; (add-to-list 'load-path "~/.emacs.d/el-get/ecb/cedet/semantic")
;;(add-to-list 'load-path "~/.emacs.d/el-get/color-theme")
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


;;all the packages we want to setup
(setq 
 el-get-sources
 '(
   (:name bbdb)
   (:name yaml-mode)
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
                                    "ant -find build.xml -q -e -Dlint.skip=true -Dskip.lint=true all")))
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
   (:name multi-web-mode
          :type git
          :url "https://github.com/fgallina/multi-web-mode.git"
          :after (lambda () (progn
                              (require 'multi-web-mode)
                              (setq mweb-default-major-mode 'html-mode)
                              (setq mweb-tags '((php-mode "<\\?php\\|<\\? \\|<\\?=" "\\?>")
                                                (python-mode "${" "}")
                                                (js2-mode "<script +\\(type=\"text/javascript\"\\|language=\"javascript\"\\)[^>]*>" "</script>")
                                                (css-mode "<style +type=\"text/css\"[^>]*>" "</style>")))
                              (setq mweb-filename-extensions '("php" "htm" "html" "ctp" "mako" "php4" "php5"))
                              (multi-web-global-mode 1))))
   )
 )

(setq semantic-python-dependency-system-include-path
      '("/Users/aaditya/work/id" "/Users/aaditya/work/id/src" "/Users/aaditya/work/id/src/id/vaitarna" "/Users/aaditya/.env/ep/lib/python2.6/site-packages" "/Users/aaditya/.env/ep/lib/python2.6" "/System/Library/Frameworks/Python.framework/Versions/2.6/lib/python2.6"))


(setq load-path (cons (expand-file-name "~/src/local/gnus/lisp") load-path))
(require 'gnus-load)

(require 'info)
(add-to-list 'Info-default-directory-list (expand-file-name "~/src/local/gnus/texi"))

(el-get)

(require 'aaditya-settings)
(require 'aaditya-packages)
(require 'aaditya-python)
(require 'aaditya-shell)

(when (fboundp 'aaditya/set-screen)
  (aaditya/set-screen))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("5600dc0bb4a2b72a613175da54edb4ad770105aa" "0174d99a8f1fdc506fa54403317072982656f127" default)))
 '(ecb-layout-name "leftright-analyse")
 '(ecb-layout-window-sizes (quote (("leftright-analyse" (ecb-directories-buffer-name 0.09829059829059829 . 0.3918918918918919) (ecb-sources-buffer-name 0.09829059829059829 . 0.2972972972972973) (ecb-history-buffer-name 0.09829059829059829 . 0.2972972972972973) (ecb-methods-buffer-name 0.23931623931623933 . 0.4864864864864865) (ecb-analyse-buffer-name 0.23931623931623933 . 0.5)))))
 '(ecb-options-version "2.40")
 '(ecb-primary-secondary-mouse-buttons (quote mouse-1--C-mouse-1))
 '(ecb-source-file-regexps (quote ((".*" ("\\(^\\(\\.\\|#\\)\\|\\(~$\\|\\.\\(elc\\|obj\\|o\\|class\\|lib\\|dll\\|a\\|so\\|cache\\|pyc\\)$\\)\\)") ("^\\.\\(emacs\\|gnus\\)$")))))
 '(ecb-source-path (quote (("/Users/aaditya/work/id" "Epsilon") ("/" "/"))))
 '(ecb-tree-indent 2)
 '(ecb-vc-enable-support nil))

(toggle-debug-on-error nil)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "white" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "apple" :family "Consolas"))))
 '(header-line ((t (:inherit mode-line :background "orange1" :foreground "#000" :box nil)))))

(put 'ido-exit-minibuffer 'disabled nil)
;;use built in theme system
;;(load-theme 'solarized-light)


;; (when (require 'color-theme-sanityinc-solarized)
;;   (color-theme-sanityinc-solarized-light))
(put 'set-goal-column 'disabled nil)
