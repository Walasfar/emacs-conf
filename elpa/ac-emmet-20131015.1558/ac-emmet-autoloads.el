;;; ac-emmet-autoloads.el --- automatically extracted autoloads (do not edit)   -*- lexical-binding: t -*-
;; Generated by the `loaddefs-generate' function.

;; This file is part of GNU Emacs.

;;; Code:

(add-to-list 'load-path (or (and load-file-name (directory-file-name (file-name-directory load-file-name))) (car load-path)))



;;; Generated autoloads from ac-emmet.el

(defface ac-emmet-candidate-face '((t (:inherit ac-candidate-face))) "\
Face for emmet candidates." :group 'auto-complete)
(defface ac-emmet-selection-face '((t (:inherit ac-selection-face))) "\
Face for the emmet selected candidate." :group 'auto-complete)
(defconst ac-emmet-source-defaults '((candidate-face . ac-emmet-candidate-face) (selection-face . ac-emmet-selection-face) (symbol . "a") (requires . 1) (action lambda nil (call-interactively 'emmet-expand-line))) "\
Defaults common to the various completion sources.")
(defvar ac-source-emmet-html-snippets (append '((candidates . ac-emmet-html-snippets-keys) (document lambda (s) (ac-emmet-document s ac-emmet-html-snippets-hash))) ac-emmet-source-defaults) "\
Auto-complete source for emmet-mode's html snippet completion.")
(defvar ac-source-emmet-html-aliases (append '((candidates . ac-emmet-html-aliases-keys) (document lambda (s) (ac-emmet-document s ac-emmet-html-aliases-hash))) ac-emmet-source-defaults) "\
Auto-complete source for emmet-mode's html alias completion.")
(defvar ac-source-emmet-css-snippets (append '((candidates . ac-emmet-css-snippets-keys) (document lambda (s) (ac-emmet-document s ac-emmet-css-snippets-hash))) ac-emmet-source-defaults) "\
Auto-complete source for emmet-mode's css snippet completion.")
(autoload 'ac-emmet-html-setup "ac-emmet" "\
Add the emmet-mode's html completion source to the front of `ac-sources'.
This affects only the current buffer." t)
(autoload 'ac-emmet-css-setup "ac-emmet" "\
Add the emmet-mode's css completion source to the front of `ac-sources'.
This affects only the current buffer." t)
(register-definition-prefixes "ac-emmet" '("ac-emmet-"))

;;; End of scraped data

(provide 'ac-emmet-autoloads)

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; no-native-compile: t
;; coding: utf-8-emacs-unix
;; End:

;;; ac-emmet-autoloads.el ends here
