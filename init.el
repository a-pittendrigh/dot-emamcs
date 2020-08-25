;;;;
;; Packages
;;;;

;; Define package repositories
(require 'package)
(add-to-list 'package-archives
             '("tromey" . "http://tromey.com/elpa/") t)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)

(add-to-list 'package-pinned-packages '(cider . "melpa-stable") t)
(add-to-list 'package-pinned-packages '(magit . "melpa-stable") t)


;; Load and activate emacs packages. Do this first so that the
;; packages are loaded before you start trying to modify them.
;; This also sets the load path.
(package-initialize)

;; Download the ELPA archive description if needed.
;; This informs Emacs about the latest versions of all packages, and
;; makes them available for download.
(when (not package-archive-contents)
  (package-refresh-contents))

;; Define he following variables to remove the compile-log warnings
;; when defining ido-ubiquitous
;; (defvar ido-cur-item nil)
;; (defvar ido-default-item nil)
;; (defvar ido-cur-list nil)
;; (defvar predicate nil)
;; (defvar inherit-input-method nil)

;; The packages you want installed. You can also install these
;; manually with M-x package-install
;; Add in your own as you wish:
(defvar my-packages
  '(;; makes handling lisp expressions much, much easier
    ;; Cheatsheet: http://www.emacswiki.org/emacs/PareditCheatsheet
    paredit

    ;; key bindings and code colorization for Clojure
    ;; https://github.com/clojure-emacs/clojure-mode
    clojure-mode

    ;; extra syntax highlighting for clojure
    clojure-mode-extra-font-locking

    ;; integration with a Clojure REPL
    ;; https://github.com/clojure-emacs/cider
    cider

    ;; allow ido usage in as many contexts as possible. see
    ;; customizations/navigation.el line 23 for a description
    ;; of ido
    ido-completing-read+

    ;; Enhances M-x to allow easier execution of commands. Provides
    ;; a filterable list of possible commands in the minibuffer
    ;; http://www.emacswiki.org/emacs/Smex
    smex

    ;; project navigation
    projectile

    ;; colorful parenthesis matching
    rainbow-delimiters

    ;; edit html tags like sexps
    tagedit

    ;; git integration
    magit))

;; On OS X, an Emacs instance started from the graphical user
;; interface will have a different environment than a shell in a
;; terminal window, because OS X does not run a shell during the
;; login. Obviously this will lead to unexpected results when
;; calling external utilities like make from Emacs.
;; This library works around this problem by copying important
;; environment variables from the user's shell.
;; https://github.com/purcell/exec-path-from-shell
(if (eq system-type 'darwin)
    (add-to-list 'my-packages 'exec-path-from-shell))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))


;; Place downloaded elisp files in ~/.emacs.d/vendor. You'll then be able
;; to load them.
;;
;; For example, if you download yaml-mode.el to ~/.emacs.d/vendor,
;; then you can add the following code to this file:
;;
;; (require 'yaml-mode)
;; (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
;; 
;; Adding this code will make Emacs enter yaml mode whenever you open
;; a .yml file
(add-to-list 'load-path "~/.emacs.d/vendor")


;;;;
;; Customization
;;;;

;; Add a directory to our load path so that when you `load` things
;; below, Emacs knows where to look for the corresponding file.
(add-to-list 'load-path "~/.emacs.d/customizations")

;; Sets up exec-path-from-shell so that Emacs will use the correct
;; environment variables
(load "shell-integration.el")

;; These customizations make it easier for you to navigate files,
;; switch buffers, and choose options from the minibuffer.
;;(load "navigation.el")

;; These customizations change the way emacs looks and disable/enable
;; some user interface elements
(load "ui.el")

;; These customizations make editing a bit nicer.
(load "editing.el")

;; Hard-to-categorize customizations
(load "misc.el")

;; For editing lisps
(load "elisp-editing.el")

;; Langauage-specific
(load "setup-clojure.el")
(load "setup-js.el")

;; my config

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;;(load-theme 'solarized-dark t)
(load-theme 'doom-one t)

(use-package company
  :ensure t
  :init
  (add-hook 'after-init-hook 'global-company-mode)
  :config
  (setq company-dabbrev-downcase 0)
  (setq company-idle-delay 0.1)
  (setq company-minimum-prefix-length 1)
  (setq company-tooltip-align-annotations t))

;; hide the menu bar and the tool bar
(menu-bar-mode -1)
(tool-bar-mode -1)

;;which key
(use-package which-key
  :ensure t
  :config
  (which-key-mode))

;;helm
(use-package helm
  :ensure t
  :init
  (require 'helm-config)
  :config
  (global-set-key (kbd "M-x") #'helm-M-x)
  (global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
  (global-set-key (kbd "C-x C-f") #'helm-find-files)
  (helm-mode 1))

(use-package projectile
  :ensure t
  :config
  (projectile-mode))

(use-package helm-projectile
  :ensure t
  :config
  (helm-projectile-on))

;; keymaps
;; find file
(global-set-key (kbd "C-c f f") 'helm-projectile-find-file)
;; search in project for text
(global-set-key (kbd "C-c f t") 'helm-do-ag-project-root)
;; magit status
(global-set-key (kbd "C-c m s") 'magit-status)
;;keymaps

;; better defaults

(add-to-list 'load-path "/better-defaults")
(require 'better-defaults)

;; god-mode

(add-to-list 'exec-path "~/bin")
  (setq cursor-type 'bar)
  (require 'god-mode)
  (defun my-god-mode-update-cursor ()
    (setq cursor-type (if (or god-local-mode buffer-read-only)
                          'box
                        'bar)))
  ;;(global-set-key (kbd "<escape>") #'god-mode-all)
  (global-set-key (kbd "C-'") 'god-mode-all)
  (add-hook 'god-mode-enabled-hook #'my-god-mode-update-cursor)
  (add-hook 'god-mode-disabled-hook #'my-god-mode-update-cursor)
  (define-key god-local-mode-map (kbd ".") #'repeat)
  (define-key god-local-mode-map (kbd "i") #'god-local-mode)
  (global-set-key (kbd "C-x C-1") #'delete-other-windows)
  (global-set-key (kbd "C-x C-2") #'split-window-below)
  (global-set-key (kbd "C-x C-3") #'split-window-right)
  (global-set-key (kbd "C-x C-0") #'delete-window)

;; god-mode


;; font size
(set-face-attribute 'default nil :height 120 :family "Fira Code Retina")


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(coffee-tab-width 2)
 '(custom-safe-themes
   '("6b2636879127bf6124ce541b1b2824800afc49c6ccd65439d6eb987dbf200c36" "f0dc4ddca147f3c7b1c7397141b888562a48d9888f1595d69572db73be99a024" "d2e9c7e31e574bf38f4b0fb927aaff20c1e5f92f72001102758005e53d77b8c9" "a3fa4abaf08cc169b61dea8f6df1bbe4123ec1d2afeb01c17e11fdc31fc66379" "0598c6a29e13e7112cfbc2f523e31927ab7dce56ebb2016b567e1eff6dc1fd4f" "52588047a0fe3727e3cd8a90e76d7f078c9bd62c0b246324e557dfa5112e0d0c" default))
 '(line-number-mode nil)
 '(package-selected-packages
   '(god-mode helm-ag doom-themes which-key-posframe auto-complete solarized-theme magit tagedit rainbow-delimiters projectile smex ido-completing-read+ cider clojure-mode-extra-font-locking clojure-mode paredit exec-path-from-shell))
 '(projectile-mode t nil (projectile)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
