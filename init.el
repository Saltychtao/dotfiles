;;; init.el --- Saltychtao's Emacs configuration
;;
;; Copyright (c) 2016-2018 Saltychtao
;;
;; Author: Saltychtao <lijh@nlp.nju.edu.cn>
;; URL: https://github.com/saltychtao/emacs.d

;; This file is not part of GNU Emacs.

;;; Commentary:

;; This is my personal Emacs configuration.  Nothing more, nothing less.

;;; License:

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:


(require 'package)
(add-to-list 'load-path (expand-file-name "private/lisp" user-emacs-directory))
(setq package-archives '(("gnu" . "http://elpa.emacs-china.org/gnu/")
                         ("melpa" . "http://elpa.emacs-china.org/melpa/")
                         ("org" . "http://elpa.emacs-china.org/org/")))
;; keep the installed packages in .emacs.d
(setq package-user-dir (expand-file-name "elpa" user-emacs-directory))
(add-to-list 'load-path package-user-dir
 )
(package-initialize)
;; update the package metadata is the local cache is missing
(unless package-archive-contents
  (package-refresh-contents))

(setq user-full-name "Saltychtao"
      user-mail-address "lijh@nlp.nju.edu.cn")

;; Always load newest byte code
(setq load-prefer-newer t)

;; reduce the frequency of garbage collection by making it happen on
;; each 50MB of allocated data (the default is on every 0.76MB)
(setq gc-cons-threshold 50000000)

;; warn when opening files bigger than 100MB
(setq large-file-warning-threshold 100000000)

(defconst saltychtao-savefile-dir (expand-file-name "private/savefile" user-emacs-directory))

;; create the savefile dir if it doesn't exist
(unless (file-exists-p saltychtao-savefile-dir)
  (make-directory saltychtao-savefile-dir))

;; the toolbar is just a waste of valuable screen estate
;; in a tty tool-bar-mode does not properly auto-load, and is
;; already disabled anyway
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

;; the blinking cursor is nothing, but an annoyance
(blink-cursor-mode -1)

;; disable the annoying bell ring
(setq ring-bell-function 'ignore)

;; disable startup screen
(setq inhibit-startup-screen t)

;; nice scrolling
(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

;; mode line settings
(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)

;; enable y/n answers
(fset 'yes-or-no-p 'y-or-n-p)

;; more useful frame title, that show either a file or a
;; buffer name (if the buffer isn't visiting a file)
(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))))

;; Emacs modes typically provide a standard means to change the
;; indentation width -- eg. c-basic-offset: use that to adjust your
;; personal indentation width, while maintaining the style (and
;; meaning) of any files you load.
(setq-default indent-tabs-mode nil)   ;; don't use tabs to indent
(setq-default tab-width 8)            ;; but maintain correct appearance

;; Newline at end of file
(setq require-final-newline t)

;; delete the selection with a keypress
(delete-selection-mode t)

;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;;revert buffers automatically when underlying files are changed externally
(global-auto-revert-mode t)

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; hippie expand is dabbrev expand on steroids
(setq hippie-expand-try-functions-list '(try-expand-dabbrev
                                         try-expand-dabbrev-all-buffers
                                         try-expand-dabbrev-from-kill
                                         try-complete-file-name-partially
                                         try-complete-file-name
                                         try-expand-all-abbrevs
                                         try-expand-list
                                         try-expand-line
                                         try-complete-lisp-symbol-partially
                                         try-complete-lisp-symbol))

;; use hippie-expand instead of dabbrev
(global-set-key (kbd "M-/") #'hippie-expand)
(global-set-key (kbd "s-/") #'hippie-expand)

;; replace buffer-menu with ibuffer
(global-set-key (kbd "C-x C-b") #'ibuffer)

;; align code in a pretty way
(global-set-key (kbd "C-x \\") #'align-regexp)

(define-key 'help-command (kbd "C-i") #'info-display-manual)

;; misc useful keybindings
(global-set-key (kbd "s-<") #'beginning-of-buffer)
(global-set-key (kbd "s->") #'end-of-buffer)
(global-set-key (kbd "s-q") #'fill-paragraph)
(global-set-key (kbd "s-x") #'execute-extended-command)

;; smart tab behavior - indent or complete
(setq tab-always-indent 'complete)

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-verbose t)

(use-package tramp
  :ensure t
  :demand t
  :config
  (setq tramp-default-method "scp"))

(use-package pyim
  :ensure t
  :demand t
  :config
  (use-package pyim-basedict
    :ensure nil
    :config (pyim-basedict-enable))
  (setq default-input-method "pyim")
  (setq pyim-default-scheme 'quanpin)

  (setq pyim-page-length 5)
  (setq pyim-page-tooltip 'posframe)
  (add-hook 'emacs-startup-hook
            #'(lambda () (pyim-restart-1 t)))
  (global-set-key (kbd "C-\\") 'toggle-input-method)
)

(use-package posframe
  :ensure t)
(use-package lisp-mode
  :config
  (defun saltychtao-visit-ielm ()
    "Switch to default `ielm' buffer.
Start `ielm' if it's not already running."
    (interactive)
    (crux-start-or-switch-to 'ielm "*ielm*"))

  (add-hook 'emacs-lisp-mode-hook #'eldoc-mode)
  (add-hook 'emacs-lisp-mode-hook #'rainbow-delimiters-mode)
  (define-key emacs-lisp-mode-map (kbd "C-c C-z") #'saltychtao-visit-ielm)
  (define-key emacs-lisp-mode-map (kbd "C-c C-c") #'eval-defun)
  (define-key emacs-lisp-mode-map (kbd "C-c C-b") #'eval-buffer)
  (add-hook 'lisp-interaction-mode-hook #'eldoc-mode)
  (add-hook 'eval-expression-minibuffer-setup-hook #'eldoc-mode))

(use-package pyvenv
  :ensure t
  :config (add-hook 'emacs-startup-hook (lambda () (pyvenv-activate (expand-file-name  "jedi" user-emacs-directory)))))


(use-package python-mode
  :ensure t
  :config
  )

(use-package py-autopep8
  :ensure
  :config
  (define-key python-mode-map (kbd "C-c C-f") #'py-autopep8-buffer)
  )

(use-package cquery
  :ensure t
  :config
  (setq cquery-executable "~/softwares/cquery-git/pkg/cquery-git/usr/bin/cquery")
  )
(use-package lsp-mode
  :ensure t
  :config
  ;; make sure we have lsp-imenu everywhere we have LSP
  (require 'lsp-imenu)
  (add-hook 'lsp-after-open-hook 'lsp-enable-imenu) 
  (use-package lsp-python
    :ensure t)
  ;; get lsp-python-enable defined
  ;; NB: use either projectile-project-root or ffip-get-project-root-directory
  ;;     or any other function that can be used to find the root directory of a project
  (lsp-define-stdio-client lsp-python "python"
                           #'projectile-project-root
                           '("pyls"))

  ;; make sure this is activated when python-mode is activated
  ;; lsp-python-enable is created by macro above
  (add-hook 'python-mode-hook #'lsp-python-enable)
  (add-hook 'python-mode-hook #'projectile-mode)
  (add-hook 'python-mode-hook '(lambda () (ignore-errors (lsp-python-enable))))
  

  (use-package lsp-ui
    :ensure t
    :config
    (setq lsp-ui-sideline-ignore-duplicate t)
    (add-hook 'lsp-mode-hook 'lsp-ui-mode)
    (setq lsp-ui-sideline-show-flycheck nil)
    (setq lsp-ui-sideline-show-symbol nil))



  (require 'company-lsp)
  (push 'company-lsp company-backends)

  ;; NB: only required if you prefer flake8 instead of the default
  ;; send pyls config via lsp-after-initialize-hook -- harmless for
  ;; other servers due to pyls key, but would prefer only sending this
  ;; when pyls gets initialised (:initialize function in
  ;; lsp-define-stdio-client is invoked too early (before server
  ;; start)) -- cpbotha
  (defun lsp-set-cfg ()
    (let ((lsp-cfg `(:pyls (:configurationSources ("flake8")))))
      ;; TODO: check lsp--cur-workspace here to decide per server / project
      (lsp--set-configuration lsp-cfg)))

  (add-hook 'lsp-after-initialize-hook 'lsp-set-cfg))

(use-package ielm
  :config
  (add-hook 'ielm-mode-hook #'eldoc-mode)
  (add-hook 'ielm-mode-hook #'rainbow-delimiters-mode))

(use-package dracula-theme
  :ensure t
  :config
  (load-theme 'dracula t))

;; highlight the current line
(global-hl-line-mode +1)

(use-package diminish
  :ensure t
  :config
  (eval-after-load "whitespace-mode" '(diminish 'whitespace-mode))
  (diminish 'volatile-highlights-mode)
  (diminish 'undo-tree-mode))

(use-package use-package-chords
  :ensure t
  :config (key-chord-mode 1))

(use-package avy
  :ensure t
  :chords (("jj" . avy-goto-char)
           ("jk" . avy-goto-word-1)
           )
  :config
  (setq avy-background t))

(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))

(use-package git-timemachine
  :ensure t
  :bind (("s-g" . git-timemachine)))

(use-package ag
  :ensure t)

(use-package projectile
  :ensure t
  :init
  (setq projectile-completion-system 'ivy)
  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (setq projectile-globally-ignored-file-suffixes (list ".json"))
  (projectile-global-mode +1)
  :bind
  (("C-c g" . projectile-grep
    )))

(defun cquery//enable ()
  (condition-case nil
      (lsp-cquery-enable)
    (user-error nil)))

  (use-package cquery
    :commands lsp-cquery-enable
    :init (add-hook 'c-mode-hook #'cquery//enable)
          (add-hook 'c++-mode-hook #'cquery//enable))
(use-package pt
  :ensure t)

(use-package expand-region
  :ensure t
  :bind ("C-=" . er/expand-region))

(use-package elisp-slime-nav
  :diminish elisp-slime-nav-mode
  :ensure t
  :config
  (dolist (hook '(emacs-lisp-mode-hook ielm-mode-hook))
    (add-hook hook #'elisp-slime-nav-mode)))

(use-package paredit
  :ensure t
  :defer t
  :init
  (progn
   (add-hook 'emacs-lisp-mode-hook #'paredit-mode)
   ;; enable in the *scratch* buffer
   (add-hook 'lisp-interaction-mode-hook #'paredit-mode)
   (add-hook 'ielm-mode-hook #'paredit-mode)
   (add-hook 'lisp-mode-hook #'paredit-mode)
   (add-hook 'eval-expression-minibuffer-setup-hook #'paredit-mode)))

(use-package paren
  :config
  (show-paren-mode +1))

(use-package smooth-scrolling
  :ensure t)

(use-package abbrev
  :diminish abbrev-mode
  :config
  (setq save-abbrevs 'silently)
  (setq abbrev-file-name (expand-file-name "abbrev_defs" saltychtao-savefile-dir))
  (setq-default abbrev-mode t))

(use-package uniquify
  :config
  (setq uniquify-buffer-name-style 'forward)
  (setq uniquify-separator "/")
  ;; rename after killing uniquified
  (setq uniquify-after-kill-buffer-p t)
  ;; don't muck with special buffers
  (setq uniquify-ignore-buffers-re "^\\*"))

;; saveplace remembers your location in a file when saving files
(require 'saveplace)
(use-package saveplace
  :config
  (setq save-place-file (expand-file-name "saveplace" saltychtao-savefile-dir))
  ;; activate it for all buffers
  (setq-default save-place t))

(use-package savehist
  :config
  (setq savehist-additional-variables
        ;; search entries
        '(search-ring regexp-search-ring)
        ;; save every minute
        savehist-autosave-interval 60
        ;; keep the home clean
        savehist-file (expand-file-name "savehist" saltychtao-savefile-dir))
  (savehist-mode +1))

(use-package recentf
  :config
  (setq recentf-save-file (expand-file-name "recentf" saltychtao-savefile-dir)
        recentf-max-saved-items 500
        recentf-max-menu-items 15
        ;; disable recentf-cleanup on Emacs start, because it can cause
        ;; problems with remote files
        recentf-auto-cleanup 'never)
  (recentf-mode +1))

(use-package windmove
  :config
  ;; use shift + arrow keys to switch between visible buffers
  (windmove-default-keybindings))

(use-package dired
  :config
  ;; dired - reuse current buffer by pressing 'a'
  (put 'dired-find-alternate-file 'disabled nil)

  ;; always delete and copy recursively
  (setq dired-recursive-deletes 'always)
  (setq dired-recursive-copies 'always)

  ;; if there is a dired buffer displayed in the next window, use its
  ;; current subdir, instead of the current subdir of this dired buffer
  (setq dired-dwim-target t)

  ;; enable some really cool extensions like C-x C-j(dired-jump)
  (require 'dired-x))

(use-package anzu
  :ensure t
  :bind (("M-%" . anzu-query-replace)
         ("C-M-%" . anzu-query-replace-regexp))
  :config
  (global-anzu-mode))

(use-package easy-kill
  :ensure t
  :config
  (global-set-key [remap kill-ring-save] 'easy-kill))

(use-package exec-path-from-shell
  :ensure t
  :config
  (when (memq window-system '(mac ns))
    (exec-path-from-shell-initialize)))

(use-package move-text
  :ensure t
  :bind
  (([(meta shift up)] . move-text-up)
   ([(meta shift down)] . move-text-down)))

(use-package rainbow-delimiters
  :diminish rainbow-delimiters-mode
  :ensure t)

(use-package rainbow-mode
  :diminish rainbow-mode
  :ensure t
  :init
  (add-hook 'prog-mode-hook #'rainbow-mode)
)

(use-package markdown-mode
  :ensure t
  :mode "\\.md\\'")

;; (use-package python-mode
;;   :ensure t
;;   :mode "\\.py\\'"
;;   :config
;;   (setq py-temp-directory "/home/user_data/lijh/tmp")
;;   )

(use-package helm-bibtex
  :ensure t
  :commands (helm-bibtex)
  :config
  (setq bibtex-completion-bibliography
        '("~/nlp/Dissertation/tex/paper.bib")))

(use-package org-ref
  :after '(org)
  :ensure t
  :config
  (setq org-ref-default-bibliography
        '("~/nlp/Dissertation/tex/paper.bib")))

(use-package company
  :ensure t
  :config
  (global-company-mode)
  (setq company-minimum-prefix-length 2)
  (setq company-lsp-enable-snippet t)
  (setq company-tooltip-align-annotations t)
  (setq company-selection-wrap-around t)
  (setq company-transformers '(company-sort-by-occurrence))
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  (define-key company-active-map (kbd "TAB") 'company-complete-common-or-cycle)
  )

(use-package hl-todo
  :ensure t
  :config
  (global-hl-todo-mode))

(use-package zop-to-char
  :ensure t
  :bind (("M-z" . zop-up-to-char)
         ("M-Z" . zop-to-char)))

(use-package flyspell
  :config
  (when (eq system-type 'windows-nt)
    (add-to-list 'exec-path "C:/Program Files (x86)/Aspell/bin/"))
  (setq ispell-program-name "aspell" ; use aspell instead of ispell
        ispell-extra-args '("--sug-mode=ultra"))
  (add-hook 'text-mode-hook #'flyspell-mode)
  )

(use-package flycheck
  :ensure t
  :config
  (add-hook 'prog-mode-hook #'flycheck-mode)
  (setq flycheck-python-flake8-executable "/home/saltychtao/softwares/anaconda3/bin/flake8")
  )

(use-package super-save
  :diminish super-save-mode
  :ensure t
  :config
  (super-save-mode +1))

(use-package crux
  :ensure t
  :bind (("C-c u o" . crux-open-with)
         ("M-o" . crux-smart-open-line)
         ("C-c f f" . crux-recentf-find-file)
         ("C-M-z" . crux-indent-defun)
         ("C-c u u" . crux-view-url)
         ("C-c u D" . crux-delete-file-and-buffer)
         ("C-c u r" . crux-rename-buffer-and-file)
         ("C-c k" . crux-kill-other-buffers)
         ("C-c TAB" . crux-indent-rigidly-and-copy-to-clipboard)
         ("C-c u I" . crux-find-user-init-file)
         ("C-c u S" . crux-find-shell-init-file)
         ("s-k" . crux-kill-whole-line)
         ("C-<backspace>" . crux-kill-line-backwards)
         ([remap move-beginning-of-line] . crux-move-beginning-of-line)
         ([(shift return)] . crux-smart-open-line)
         ([remap kill-whole-line] . crux-kill-whole-line)
         ))

(use-package diff-hl
  :ensure t
  :config
  (global-diff-hl-mode +1)
  (add-hook 'dired-mode-hook 'diff-hl-dired-mode)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))

(use-package which-key
  :ensure t
  :diminish which-key-mode
  :config
  (which-key-mode +1))

(use-package undo-tree
  :diminish undo-tree-mode
  :ensure t
  :config
  ;; autosave the undo-tree history
  (setq undo-tree-history-directory-alist
        `((".*" . ,temporary-file-directory)))
  (setq undo-tree-auto-save-history t))

(use-package speed-type
  :ensure t)

(use-package ivy
  :ensure t
  :config
  (ivy-mode 1))
  ;; :commands (swiper)
  ;; :config
  ;; (ivy-mode 1')
  ;; (setq ivy-use-virtual-buffers t)
  ;; (setq ivy-re-builders-alist
  ;;       '((swiper . ivy--regex-plus)
  ;;         ))
  ;; (setq enable-recursive-minibuffers t)
  ;; (global-set-key (kbd "C-c C-r") 'ivy-resume)
  ;; (global-set-key (kbd "<f6>") 'ivy-resume))

(use-package ace-window
  :ensure t
  :bind
  (("M-o"  . 'ace-window))
  :config
  (global-set-key [remap other-window] 'ace-window))

(use-package yasnippet
  :ensure t
  :config
  ;; Add yasnippet support for all company backends
;; https://github.com/syl20bnr/spacemacs/pull/179
  (defvar company-mode/enable-yas t
  "Enable yasnippet for all backends.")
  (defun company-mode/backend-with-yas (backend)
  (if (or (not company-mode/enable-yas) (and (listp backend) (member 'company-yasnippet backend)))
      backend
    (append (if (consp backend) backend (list backend))
            '(:with company-yasnippet))))

  ;; (setq company-backends (mapcar #'company-mode/backend-with-yas company-backends))
  (yas-reload-all)
  (add-hook 'prog-mode-hook #'yas-minor-mode))

(use-package yasnippet-snippets
  :ensure t)

(use-package swiper
  :ensure t
  :bind
  ("\C-s" .  'swiper))

(use-package counsel
  :ensure t
  :config
  (ivy-mode 1)
  :bind
  (("M-x" . 'counsel-M-x)
   ("C-x C-f" . 'counsel-find-file)
  ( "<f1> f" . 'counsel-describe-function)
  ( "<f1> v" . 'counsel-describe-variable)
  ( "<f1> l" . 'counsel-find-library)
  ( "<f2> i" . 'counsel-info-lookup-symbol)
  ( "<f2> u" . 'counsel-unicode-char)
  ( "C-c k" . 'counsel-ag)
  ( "C-x l" . 'counsel-locate)
  ))

;; temporarily highlight changes from yanking, etc
(use-package volatile-highlights
  :diminish 'volatile-highlights-mode
  :ensure t
  :config
  (volatile-highlights-mode +1))

(setq initial-major-mode 'text-mode)
(setq initial-scratch-message ";;; Hi, Saltychtao! Emacs loves you!")

;; config changes made through the customize UI will be stored here
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(electric-pair-mode t)
(setq electric-pair-inhibit-predicate 'electric-pair-conservative-inhibit)

(when (file-exists-p custom-file)
  (load custom-file))


(require 'org-capture)
(require 'org-agenda)
(require 'org)
(setq org-default-notes-file "~/org/notes.org")

(setq org-capture-templates nil)
(push '("t" "TODO item" entry
        (file+headline "~/org/gtd.org" "TODOS")
        "* TODO [#B] %?\n %i\n"
        :empty-lines 1)
      org-capture-templates)

(push '("i" "Ideas" entry
        (file+headline "~/org/gtd.org" "Research Idea")
        "* TODO [#B] %?\n %i\n"
        :empty-lines 1)
      org-capture-templates)

(push '("w" "Work" entry
        (file+headline "~/org/gtd.org" "Work")
        "* TODO [#B] %?\n %i\n"
        :empty-lines 1)
      org-capture-templates)

(push '("r" "Readed Papers" entry
        (file+headline "~/org/gtd.org" "Readed Papers")
        "* DONE %?\n %i\n"
        :empty-lines 1)
      org-capture-templates)

(push '("m" "Memo List" entry
        (file+headline "~/org/note.org" "Memo")
        "* [[%^{url}][%^{name}]]"
        :empty-lines 1)
      org-capture-templates)





;; org mode export to chinese pdf
(add-hook 'org-mode-hook (lambda () (setq truncate-lines nil)))

(require 'ox-latex)
(add-to-list 'org-latex-classes
             '("cn-article"
               "\\documentclass[10pt,a4paper]{article}
\\usepackage{graphicx}
\\usepackage{xcolor}
\\usepackage{xeCJK}
\\usepackage{lmodern}
\\usepackage{verbatim}
\\usepackage{fixltx2e}
\\usepackage{longtable}
\\usepackage{float}
\\usepackage{tikz}
\\usepackage{wrapfig}
\\usepackage{soul}
\\usepackage{textcomp}
\\usepackage{listings}
\\usepackage{geometry}
\\usepackage{algorithm}
\\usepackage{algorithmic}
\\usepackage{marvosym}
\\usepackage{wasysym}
\\usepackage{latexsym}
\\usepackage{natbib}
\\usepackage{fancyhdr}
\\usepackage[xetex,colorlinks=true,CJKbookmarks=true,
linkcolor=blue,
urlcolor=blue,
menucolor=blue]{hyperref}
\\usepackage{fontspec,xunicode,xltxtra}
\\setmainfont[BoldFont=Adobe Heiti Std]{Adobe Song Std}
\\newfontinstance\\MONO{\\fontnamemono}
\\newcommand{\\mono}[1]{{\\MONO #1}}
\\setCJKmainfont[Scale=0.9]{Adobe Heiti Std}%中文字体
\\setCJKmonofont[Scale=0.9]{Adobe Heiti Std}
\\hypersetup{unicode=true}
\\geometry{a4paper, textwidth=6.5in, textheight=10in,
marginparsep=7pt, marginparwidth=.6in}
\\definecolor{foreground}{RGB}{220,220,204}%浅灰
\\definecolor{background}{RGB}{62,62,62}%浅黑
\\definecolor{preprocess}{RGB}{250,187,249}%浅紫
\\definecolor{var}{RGB}{239,224,174}%浅肉色
\\definecolor{string}{RGB}{154,150,230}%浅紫色
\\definecolor{type}{RGB}{225,225,116}%浅黄
\\definecolor{function}{RGB}{140,206,211}%浅天蓝
\\definecolor{keyword}{RGB}{239,224,174}%浅肉色
\\definecolor{comment}{RGB}{180,98,4}%深褐色
\\definecolor{doc}{RGB}{175,215,175}%浅铅绿
\\definecolor{comdil}{RGB}{111,128,111}%深灰
\\definecolor{constant}{RGB}{220,162,170}%粉红
\\definecolor{buildin}{RGB}{127,159,127}%深铅绿
\\punctstyle{kaiming}
\\title{}
\\fancyfoot[C]{\\bfseries\\thepage}
\\chead{\\MakeUppercase\\sectionmark}
\\pagestyle{fancy}
\\tolerance=1000
[NO-DEFAULT-PACKAGES]
[NO-PACKAGES]"
("\\section{%s}" . "\\section*{%s}")
("\\subsection{%s}" . "\\subsection*{%s}")
("\\subsubsection{%s}" . "\\subsubsection*{%s}")
("\\paragraph{%s}" . "\\paragraph*{%s}")
("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(setq org-latex-pdf-process
      '("xelatex -interaction nonstopmode -output-directory %o %f"
        "bibtex %b"
        "xelatex -interaction nonstopmode -output-directory %o %f"
        "xelatex -interaction nonstopmode -output-directory %o %f"))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (shell . t)))

;;; org agenda
(setq org-agenda-files (file-expand-wildcards "~/org/*.org"))

;; disable auto backup
(setq backup-directory-alist '(("" . "~/.emacs.d/emacs-backup")))
;; disable lock files
(setq create-lockfiles nil)

(require 'keys)
(require 'jh)
;;; init.el ends here
(put 'erase-buffer 'disabled nil)
