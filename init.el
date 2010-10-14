(setq load-path
      (append (list "~/.emacs.d/") load-path))
(setq load-path
      (append (list "~/.emacs.d/el-get/el-get") load-path))
(setq load-path
      (append (list "~/.emacs.d/color-theme-6.6.0") load-path))
(setq load-path
      (append (list "~/.emacs.d/elscreen-1.4.6") load-path))
(setq load-path
      (append (list "~/.emacs.d/elscreen-color-theme-0.0.0") load-path))
(setq load-path
      (append (list "~/.emacs.d/elscreen-dired-0.1.0") load-path))
(setq load-path
      (append (list "~/.emacs.d/elscreen-server-0.2.0") load-path))

(setq package-archives (quote (("gnu" . "http://elpa.gnu.org/packages/") 
			       ("elpa" . "http://tromey.com/elpa/"))))
(require 'package)
(package-initialize)
(require 'el-get)

(setq el-get-sources
      '((:name yaml-mode        :type elpa)
	(:name rainbow-mode     :type elpa)
	(:name asciidoc         :type elpa)
	(:name js2-mode         :type elpa)
	;; (:name "el-get" 
	;;        :type "git" 
	;;        :url "git://github.com/dimitri/el-get.git" 
	;;        :features el-get)
        (:name magit
	       :type git
	       :url "http://github.com/philjackson/magit.git"
	       :info "."
	       :build ("make EMACS=/Users/aaditya/Applications/Emacs.app/Contents/MacOS/Emacs"))
        (:name github
               :type git
               :url "http://github.com/dudleyf/color-theme-github.git")
        (:name vibrant-ink
               :type git
               :url "http://github.com/mig/color-theme-vibrant-ink.git")
        (:name smex
               :type git
               :url "http://github.com/nonsequitur/smex.git")
        (:name ectags
               :type git
               :url "git://repo.or.cz/ectags.git")
        (:name egg
	       :type git
	       :url "http://github.com/bogolisk/egg.git")
        (:name regex-tool
	       :type git
	       :url "http://github.com/jwiegley/regex-tool.git")
        (:name git-blame
	       :type http
	       :url "http://github.com/tsgates/git-emacs/raw/master/git-blame.el")
	(:name yasnippet
 	       :type git-svn
 	       :url "http://yasnippet.googlecode.com/svn/trunk/")
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
               :url "http://www.emacswiki.org/emacs/download/visible-mark.el")
        (:name python-mode
               :type http
               :url "http://bazaar.launchpad.net/~python-mode-devs/python-mode/python-mode/download/head%3A/2%40fb98634b-d22b-0410-a57a-e996bee27b70%3Atrunk%252Fpython-mode%3Apython-mode.el/python-mode.el")
        (:name pymacs
               :type git
               :url "http://github.com/pinard/Pymacs.git")
        (:name ropemacs
               :type http-tar
               :options ("zxf")
               :url "http://bitbucket.org/agr/ropemacs/get/tip.tar.gz")
        (:name ipython
               :type http
               :url "http://ipython.scipy.org/dist/ipython.el")
        (:name apel
               :type http-tar
               :options ("zxf")
               :url "http://kanji.zinbun.kyoto-u.ac.jp/~tomo/lemi/dist/apel/apel-10.8.tar.gz")
        ;; (:name elscreen
        ;;        :type http
        ;;        :url "ftp://ftp.morishima.net/pub/morishima.net/naoto/ElScreen/elscreen-1.4.6.tar.gz")
        ;; (:name elscreen-color-theme
        ;;        :type http
        ;;        :url "ftp://ftp.morishima.net/pub/morishima.net/naoto/ElScreen/elscreen-color-theme-0.0.0.tar.gz")
        ;; (:name elscreen-dnd
        ;;        :type http
        ;;        :url "ftp://ftp.morishima.net/pub/morishima.net/naoto/ElScreen/elscreen-dnd-0.0.0.tar.gz")
        ;; (:name elscreen-dired
        ;;        :type http
        ;;        :url "ftp://ftp.morishima.net/pub/morishima.net/naoto/ElScreen/elscreen-dired-0.1.0.tar.gz")
        ;; (:name elscreen-server
        ;;        :type http
        ;;        :url "ftp://ftp.morishima.net/pub/morishima.net/naoto/ElScreen/elscreen-server-0.2.0.tar.gz")
        (:name mysql
               :type http
               :url "http://www.emacswiki.org/emacs/download/mysql.el")
        (:name sql-completion
               :type http
               :url "http://www.emacswiki.org/emacs/download/sql-completion.el")
        (:name moz
               :type http
               :url "http://github.com/bard/mozrepl/raw/master/chrome/content/moz.el")
        (:name sml-modeline
               :type http
               :url "http://www.emacswiki.org/emacs/download/sml-modeline.el")
        (:name scratch
               :type git
               :url "http://github.com/ieure/scratch-el.git")
        (:name pylookup
               :type git
               :url "http://github.com/tsgates/pylookup.git")
        (:name auctex
               :type cvs
               :module "auctex"
               :url ":pserver:anonymous@cvs.sv.gnu.org:/sources/auctex"
               :build ("./autogen.sh" "./configure --with-emacs=/Users/aaditya/Applications/Emacs.app/Contents/MacOS/Emacs --with-lispdir . --with-texmf-dir=/Library/TeX/Root/texmf" "make")
               :load  ("auctex.el" "preview/prv-emacs.el" "preview/preview.el" "preview/preview-latex.el")
               :info "doc")
        )
      )

(el-get)

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
 '(egg-enable-tooltip t)
 '(elscreen-display-screen-number nil)
 '(elscreen-tab-display-control nil)
 '(elscreen-tab-display-kill-screen (quote right))
 '(eshell-modules-list (quote (eshell-alias eshell-banner eshell-basic eshell-cmpl eshell-dirs eshell-glob eshell-hist eshell-ls eshell-pred eshell-prompt eshell-rebind eshell-script eshell-smart eshell-term eshell-unix eshell-xtra)))
 '(ido-default-file-method (quote selected-window))
 '(ipython-command "/Users/aaditya/src/id/vaitarna/pylons-shell")
 '(ns-function-modifier (quote hyper))
 '(regex-tool-backend (quote perl))
 '(show-paren-style (quote expression))
 '(tabbar-separator (quote ("\"                             \""))))

(toggle-debug-on-error nil)
