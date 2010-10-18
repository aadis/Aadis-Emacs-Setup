(require 'python-mode)

(require 'pymacs)
;;(pymacs-load "ropemacs" "rope-")
(setq ropemacs-confirm-saving nil
      ropemacs-guess-project t
      ropemacs-enable-autoimport t
      )

(require 'ipython)
;;(setq py-python-command-args '( "-colors" "Linux"))

(autoload 'python-pylint "python-pylint")
(autoload 'pylint "python-pylint")
(autoload 'python-pep8 "python-pep8")
(autoload 'pep8 "python-pep8")


(setq ipython-completion-command-string
      "print(';'.join(__IP.Completer.all_completions('%s'))) #PYTHON-MODE SILENT\n")

(add-to-list 'load-path "~/.emacs.d/el-get/flymake-python")

;; (when (load "flymake" t)
;;   (defun flymake-pylint-init ()
;;     (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                        'flymake-create-temp-inplace))
;;            (local-file (file-relative-name
;;                         temp-file
;;                         (file-name-directory buffer-file-name))))
;;       (list "~/.emacs.d/el-get/flymake-python/pyflymake.py" (list local-file))))

;;   (add-to-list 'flymake-allowed-file-name-masks
;;                '("\\.py\\'" flymake-pylint-init)))

;; Not happy that I have to specify the path to pdb. It should be on
;; my path already. Need to find or write a `which` command for emacs.
(setq pdb-path '/usr/bin/pdb
      gud-pdb-command-name (symbol-name pdb-path))

;; when running pdb, prepopulate the current buffer's name
(defadvice pdb (before gud-query-cmdline activate)
  "Provide a better default command line when called interactively."
  (interactive
   (list (gud-query-cmdline pdb-path
			    (file-name-nondirectory buffer-file-name)))))

(defun py-doc-search (w)
  "Launch PyDOC on the Word at Point"
  (interactive
   (list (let* ((word (thing-at-point 'word))
                (input (read-string
                        (format "pydoc entry%s: "
                                (if (not word) "" (format " (default %s)" word))))))
           (if (string= input "")
               (if (not word) (error "No pydoc args given")
                 word)                  ;sinon word
             input))))                  ;sinon input
  (shell-command (concat py-python-command " -c \"from pydoc import help;help(\'" w "\')\"") "*PYDOCS*")
  (view-buffer-other-window "*PYDOCS*" t 'kill-buffer-and-window))

(add-hook 'python-mode-hook
          '(lambda () (eldoc-mode 1)
             (unless (eq buffer-file-name nil) (flymake-mode nil)) ;dont invoke flymake on temporary buffers for the interpreter
             (set-variable 'py-indent-offset 4)
             (set-variable 'py-smart-indentation nil)
             (set-variable 'indent-tabs-mode nil)
             (local-set-key "\C-c\C-f" 'py-doc-search)
             (eldoc-mode 1)
             ;;(highlight-beyond-fill-column)

             ;;(pabbrev-mode)
             (abbrev-mode)

             ) t)

(defun pylons-shell (&optional argprompt)
  (interactive "P")
  ;; Set the default shell if not already set
  (labels ((read-pylons-project-dir
	    (prompt dir)
	    (let* ((dir (read-directory-name prompt dir))
		   (manage (expand-file-name (concat dir "pylons-shell"))))
	      (if (file-exists-p manage)
		  (expand-file-name dir)
		(progn
		  (message "%s is not a Pylons project directory" manage)
		  (sleep-for .5)
		  (read-pylons-project-dir prompt dir))))))
    (let* ((dir (read-pylons-project-dir
		 "project directory: "
		 default-directory))
	   (project-name (first
			  (remove-if (lambda (s) (or (string= "src" s) (string= "" s)))
				     (reverse (split-string dir "/")))))
	   (buffer-name (format "pylons-%s" project-name))
	   (manage (concat dir "pylons-shell")))
      (cd dir)
      (if (not (equal (buffer-name) buffer-name))
	  (switch-to-buffer-other-window
	   (apply 'make-comint buffer-name manage nil '("shell")))
	(apply 'make-comint buffer-name manage nil '("shell")))
      (make-local-variable 'comint-prompt-regexp)
      (setq comint-prompt-regexp (concat py-shell-input-prompt-1-regexp "\\|"
					 py-shell-input-prompt-2-regexp "\\|"
					 "^([Pp]db) "))
      (ansi-color-for-comint-mode-on)
      (add-hook 'comint-output-filter-functions
		'py-comint-output-filter-function)
      (add-hook 'comint-output-filter-functions
		'ansi-color-process-output)
      ;; pdbtrack

      (add-hook 'comint-output-filter-functions 'py-pdbtrack-track-stack-file)
      (setq py-pdbtrack-do-tracking-p t)
      (set-syntax-table py-mode-syntax-table)
      (use-local-map py-shell-map)
      (run-hooks 'py-shell-hook))))

;; Additional functionality that makes flymake error messages appear
;; in the minibuffer when point is on a line containing a flymake
;; error. This saves having to mouse over the error, which is a
;; keyboard user's annoyance

;;flymake-ler(file line type text &optional full-file)
(defun show-fly-err-at-point ()
  "If the cursor is sitting on a flymake error, display the
message in the minibuffer"
  (interactive)
  (let ((line-no (line-number-at-pos)))
    (dolist (elem flymake-err-info)
      (if (eq (car elem) line-no)
          (let ((err (car (second elem))))
            (message "%s" (fly-pyflake-determine-message err)))))))

(defun fly-pyflake-determine-message (err)
  "pyflake is flakey if it has compile problems, this adjusts the
message to display, so there is one ;)"
  (cond ((not (or (eq major-mode 'Python) (eq major-mode 'python-mode) t)))
        ((null (flymake-ler-file err))
         ;; normal message do your thing
         (flymake-ler-text err))
        (t ;; could not compile err
         (format "compile error, problem on line %s" (flymake-ler-line err)))))

(defadvice flymake-goto-next-error (after display-message activate compile)
  "Display the error in the mini-buffer rather than having to mouse over it"
  (show-fly-err-at-point))

(defadvice flymake-goto-prev-error (after display-message activate compile)
  "Display the error in the mini-buffer rather than having to mouse over it"
  (show-fly-err-at-point))

(defadvice flymake-mode (before post-command-stuff activate compile)
  "Add functionality to the post command hook so that if the
cursor is sitting on a flymake error the error information is
displayed in the minibuffer (rather than having to mouse over
it)"
  (set (make-local-variable 'post-command-hook)
       (cons 'show-fly-err-at-point post-command-hook)))

;; load pylookup when compile time
(setq pylookup-dir "/Users/aaditya/Documents/references")

(eval-when-compile (require 'pylookup))

;; set executable file and db file
;;(setq pylookup-program (concat pylookup-dir "/pylookup.py"))
(setq pylookup-db-file (concat pylookup-dir "/pylookup.db"))

;; to speedup, just load it on demand
(autoload 'pylookup-lookup "pylookup"
  "Lookup SEARCH-TERM in the Python HTML indexes." t)

(autoload 'pylookup-update "pylookup"
  "Run pylookup-update and create the database at `pylookup-db-file'." t)

(global-set-key "\C-ch" 'pylookup-lookup)

(provide 'aaditya-python)
