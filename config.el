;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Sappinandana Akamphon"
      user-mail-address "sup@engr.tu.ac.th")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Liberation Mono" :size 14))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

(setq doom-localleader-key ",")

(map! (:map LaTeX-mode-map
            :localleader                  ; Use local leader
            :desc "TeX-command-run-all" "a" #'TeX-command-run-all
            :desc "Build with LatexMk" "b" #'latex/build
            :desc "View" "v" #'TeX-view
            :desc "LaTeX-environment" "e" #'LaTeX-environment)) ; Add which-key description

;; (setq latex-build-command "LatexMk")
(defun latex/build ()
  (interactive)
  (progn
    (let ((TeX-save-query nil))
      (TeX-save-document (TeX-master-file)))
    (TeX-command TeX-command-default 'TeX-master-file -1)
      )
    )

(require 'smtpmail)
(setq message-send-mail-function 'smtpmail-send-it
      smtpmail-stream-type 'starttls
      smtpmail-starttls-credentials '(("smtp.gmail.com" "587" nil nil))
      smtpmail-smtp-user "sup@engr.tu.ac.th"
      smtpmail-default-smtp-server "smtp.gmail.com"
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587)

(after! mu4e
  (setf (alist-get 'delete mu4e-marks)
        (list :char '("D" . "x")
              :prompt "Delete"
              :show-target (lambda (_target) "delete")
              :action (lambda (docid _msg target) (mu4e--server-remove docid))))
  (setq mu4e-get-mail-command (format "INSIDE_EMACS=%s mbsync -a" emacs-version)
        epa-pinentry-mode 'ask)
  (pinentry-start)
  )

(setq tab-always-indent t)

(eval-after-load "ox-latex"
  '(add-to-list 'org-latex-classes
                '("kaobook"
                  "\\documentclass{kaobook}"
                  ("\\chapter{%s}" . "\\chapter*{%s}")
                  ("\\section{%s}" . "\\section*{%s}")
                  ("\\subsection{%s}" . "\\subsection*{%s}")
                  ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                  ("\\paragraph{%s}" . "\\paragraph*{%s}")
                  ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
  )

(eval-after-load "ox-latex"
  '(setq org-latex-compiler "xelatex"))

(setq org-babel-python-command "python")
