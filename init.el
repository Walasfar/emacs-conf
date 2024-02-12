;; Interface tweaks

(setq inhibit-startup-message t)
(setq-default cursor-type 'bar)
(tool-bar-mode -1)
(toggle-scroll-bar -1)
(menu-bar-mode -1)
(global-display-line-numbers-mode)
(show-paren-mode t)
(fset 'yes-or-no-p 'y-or-n-p)
(setq make-backup-files        nil)
(setq auto-save-list-file-name nil)
(setq auto-save-default        nil)


;; Keybinding

(global-set-key (kbd "<f5>") 'revert-buffer)
(global-set-key (kbd "C-c M-k") 'comment-region)
(global-set-key (kbd "C-c M-u") 'uncomment-region)

;; ORG-mode configs

;; Ukrainian PC

(use-package reverse-im
  :ensure t
  :custom
  (reverse-im-input-methods '("ukrainian-computer"))
  ;; (reverse-im-activate "ukrainian-computer") ; the legacy way
  :config
  (reverse-im-mode t))

(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode t))))


;; Configuring a package manager repos and installers.

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)


(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))


;; Themes & fonts
(use-package dracula-theme
  :ensure t
  :config (load-theme 'dracula t))

;; (use-package zenburn-theme
;;   :ensure t
;;   :config (load-theme 'zenburn t))

(set-frame-font "Source Code Pro 10" nil t)

;; Search & buffers

(use-package transpose-frame
  :ensure t)

(use-package ace-window
  :ensure t
  :init
  (progn
    (custom-set-faces
     '(aw-leading-char-face
       ((t (:inherit ace-jump-face-foreground :height 2.0)))))
    (global-set-key [remap other-window] 'ace-window)))

(use-package which-key
  :ensure t
  :config (which-key-mode))

(use-package counsel
  :ensure t)

(use-package swiper
  :ensure try
  :config
  (progn
    (ivy-mode 1)
    (setq ivy-use-virtual-buffers t)
    (global-set-key "\C-s" 'swiper)
    (global-set-key (kbd "C-c C-r") 'ivy-resume)
    (global-set-key (kbd "<f6>") 'ivy-resume)
    (global-set-key (kbd "M-x") 'counsel-M-x)
    (global-set-key (kbd "C-x C-f") 'counsel-find-file)
    (global-set-key (kbd "<f1> f") 'counsel-describe-function)
    (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
    (global-set-key (kbd "<f1> l") 'counsel-load-library)
    (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
    (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
    (global-set-key (kbd "C-c g") 'counsel-git)
    (global-set-key (kbd "C-c j") 'counsel-git-grep)
    (global-set-key (kbd "C-c k") 'counsel-ag)
    (global-set-key (kbd "C-x l") 'counsel-locate)
    (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
    (define-key read-expression-map (kbd "C-r") 'counsel-expression-history)))

;; SLIME & SLIMY-company


(require 'cl-lib)
(setq-default inferior-lisp-program "sbcl")


(use-package slime
  :ensure t
  :config
  (progn
    (slime-setup '(slime-asdf
		   slime-fancy
		   slime-company
		   slime-indentation))
    (setq-default slime-net-coding-system 'utf-8-unix)))

(use-package slime-company
  :after (slime company)
  :config
  (progn
    (slime-setup '(slime-fancy slime-company))
    (setq slime-company-completion 'fuzzy
	  slime-company-after-completion 'slime-company-just-one-space)
    (define-key company-active-map (kbd "\C-n") 'company-select-next)
    (define-key company-active-map (kbd "\C-p") 'company-select-previous)
    (define-key company-active-map (kbd "\C-d") 'company-show-doc-buffer)
    (define-key company-active-map (kbd "M-.") 'company-show-location)))


(use-package smartparens
  :ensure t
  :init (smartparens-global-mode)
  :config (progn (sp-local-pair
		  (list 'slime-repl-mode'lisp-mode) "`" nil :actions nil)
		 (sp-local-pair
		  (list 'slime-repl-mode 'lisp-mode) "'" nil :actions nil)

		 (sp-pair "'" nil :unless '(sp-point-after-word-p))))

(use-package rainbow-delimiters
  :ensure t
  :config
  (add-hook 'lisp-mode-hook (lambda () (rainbow-delimiters-mode t))))


;; Python development

(use-package elpy
  :ensure t
  :init
  (elpy-enable))













(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(dracula))
 '(custom-safe-themes
   '("b54bf2fa7c33a63a009f249958312c73ec5b368b1094e18e5953adb95ad2ec3a" "d19f00fe59f122656f096abbc97f5ba70d489ff731d9fa9437bac2622aaa8b89" default))
 '(delete-selection-mode nil)
 '(package-selected-packages
   '(ac-emmet doom-modeline elpy emmet-mode hc-zenburn-theme zenburn-theme reverse-im transpose-frame slime-company org-bullets dracula-theme use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(aw-leading-char-face ((t (:inherit ace-jump-face-foreground :height 2.0)))))
