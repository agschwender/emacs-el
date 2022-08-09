(require 'package)
(package-initialize)

(add-to-list 'package-archives
	     '("melpa-stable" . "https://stable.melpa.org/packages/"))

(require 'align)
(require 'ansi-color)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MISC. CUSTOMIZATIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Save open buffers
(setq desktop-dirname "~/.emacs.d/"
      desktop-path (list desktop-dirname))
(desktop-save-mode 1)

;; Disable bell
(setq visible-bell 1)

;; The title of each emacs frame should be "emacs: <buffer_name>".
(setq frame-title-format "emacs: %b")

;; On fast terminals there is no disadvantage to echoing quickly.
(setq echo-keystrokes 0.1)

;; Files should always end in newlines (this setting is the default).
(setq require-final-newline t)

;; Blinking things are annoying.
(blink-cursor-mode nil)

;; Always use transient marks.
(transient-mark-mode 1)

;; Insure that buffer names are unique even when filenames are not.
(toggle-uniquify-buffer-names)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;; Avoid making backups files; use version control for anything important.
(setq make-backup-files nil)

;; Disable the annoying and useless toolbar.
(tool-bar-mode 0)
(menu-bar-mode 0)

;; Configure the mode line.
(setq column-number-mode t)
(setq line-number-mode t)

;; OBSOLETE
;; Enable the "iswitchb" global minor mode (smart buffer switching).
(iswitchb-mode t)

;; Disable that annoying only-a-double-space-can-end-a-sentence convention.
(setq sentence-end-double-space nil)

;; Disable splash screen
(setq inhibit-startup-message t)

;; Display trailing whitespace
(setq-default show-trailing-whitespace t)

;; Notice password prompts and turn off echoing for them
(add-hook 'comint-output-filter-functions 'comint-watch-for-password-prompt)

;; Copy to clipboard
(setq x-select-enable-clipboard t)

;; Set paths for shell
(setq exec-path-from-shell-variables (quote ("PATH" "MANPATH" "GOPATH" "JAVA_HOME")))
(exec-path-from-shell-initialize)

;; Set the fill column size
(setq fill-column 72)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Theme
;; Available:
;;   * zenburn
;;   * tomorrow-bright, tomorrow-day, tomorrow-night, tomorrow-blue,
;;     tomorrow-eighties
;;   * wombat
;;   * solarized-light, solarized-dark
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'after-init-hook (lambda () (load-theme 'sanityinc-tomorrow-eighties t)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; multiple-cursors
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
(global-set-key (kbd "s-<mouse-1>") 'mc/add-cursor-on-click)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Flycheck
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; http://www.flycheck.org/manual/latest/index.html
(require 'flycheck)

;; turn on flychecking globally
(add-hook 'after-init-hook #'global-flycheck-mode)

;; disable jshint since we prefer eslint checking
(setq-default flycheck-disabled-checkers
  (append flycheck-disabled-checkers
    '(javascript-jshint)))

;; use eslint with web-mode for js and jsx files
(flycheck-add-mode 'javascript-eslint 'web-mode)
(flycheck-add-mode 'javascript-eslint 'js2-mode)

;; disable json-jsonlist checking for json files
(setq-default flycheck-disabled-checkers
  (append flycheck-disabled-checkers
    '(json-jsonlist)))

;; https://github.com/purcell/exec-path-from-shell
;; only need exec-path-from-shell on OSX
;; this hopefully sets up path and other vars better
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

(defvar tabs-always-indent nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Search
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'isearch-mode-end-hook 'my-goto-match-beginning)
(defun my-goto-match-beginning ()
    (when (and isearch-forward
	       (not isearch-mode-end-hook-quit))
      (goto-char isearch-other-end)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Go
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'go-mode-hook
	  (lambda()
	    (add-hook 'before-save-hook #'gofmt-before-save)
	    (setq gofmt-args (list "-s"))
	    (setq tab-width 4)
	    (setq fill-column 72)
	    (setq fill-prefix "// ")
	    (add-hook 'write-file-hooks 'delete-trailing-whitespace nil t)))
(add-to-list 'auto-mode-alist '("\.go$" . go-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Html
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'html-mode-hook
	  (lambda()
	    (setq indent-tabs-mode nil)
	    (setq tab-width 2)
	    (add-hook 'write-file-hooks 'delete-trailing-whitespace nil t)))

(add-to-list 'auto-mode-alist '("\.html$" . html-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Javascript
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my-js2-mode-hook ()
  (setq tabs-always-indent nil)
  (setq tab-width 2)
  (setq c-basic-offset 2)
  (setq js2-basic-offset 2)
  (setq indent-tabs-mode nil)
  (add-hook 'write-file-hooks 'delete-trailing-whitespace nil t))

(setq js2-strict-trailing-comma-warning nil)

(add-hook 'js2-mode-hook 'my-js2-mode-hook)

(defun my-typescript-mode-hook ()
  (setq tabs-always-indent nil)
  (setq typescript-indent-level 2)
  (setq indent-tabs-mode nil)
  (add-hook 'write-file-hooks 'delete-trailing-whitespace nil t))

(add-hook 'typescript-mode-hook 'my-typescript-mode-hook)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; JSON
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun format-file-json ()
  (interactive)
  (shell-command-on-region (point-min) (point-max) "python -mjson.tool" t t))

(add-hook 'json-mode-hook
	  (lambda()
	    (setq indent-tabs-mode nil)
	    (setq tab-width 2)
	    (local-set-key (kbd "C-c C-f") 'format-file-json)
	    (add-hook 'write-file-hooks 'delete-trailing-whitespace nil t)))

(add-to-list 'auto-mode-alist '("\.json$" . json-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Python
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'python-mode-hook
	  (lambda()
	    (setq indent-tabs-mode nil)
	    (setq python-indent-offset 4)
	    (add-hook 'write-file-hooks 'delete-trailing-whitespace nil t)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Sass
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'scss-mode-hook
	  (lambda()
	    (setq indent-tabs-mode nil)
	    (setq tab-width 2)
	    (setq scss-compile-at-save nil)
	    (add-hook 'write-file-hooks 'delete-trailing-whitespace nil t)))

(add-to-list 'auto-mode-alist '("\.scss$" . scss-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Yaml
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'yaml-mode-hook
	  (lambda()
	    (add-hook 'write-file-hooks 'delete-trailing-whitespace nil t)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Javascript
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defvar web-mode-markup-indent-offset)
(defvar web-mode-css-indent-offset)
(defvar web-mode-code-indent-offset)
(defvar web-mode-enable-auto-quoting)
(defvar web-mode-indent-style)
(defvar web-mode-indentation-params)

(defun my-web-mode-hook ()
  (setq tabs-always-indent nil)
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-enable-auto-quoting nil)
  (setq web-mode-indent-style 2)
  (setq indent-tabs-mode nil)
  (add-to-list 'web-mode-indentation-params '("lineup-args" . nil))
  (add-to-list 'web-mode-indentation-params '("lineup-calls" . nil))
  (add-to-list 'web-mode-indentation-params '("lineup-concats" . nil))
  (add-to-list 'web-mode-indentation-params '("lineup-ternary" . nil))
  (web-mode-set-content-type "jsx")
  (add-hook 'write-file-hooks 'delete-trailing-whitespace nil t))

(add-hook 'web-mode-hook 'my-web-mode-hook)
(add-to-list 'auto-mode-alist '("\.jsx$" . web-mode))
(add-to-list 'auto-mode-alist '("\.js$" . web-mode))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ruby
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my-ruby-mode-hook()
  (setq indent-tabs-mode nil)
  (setq ruby-use-smie nil)
  (setq ruby-deep-indent-paren nil)
  (add-hook 'write-file-hooks 'delete-trailing-whitespace nil t))

(add-hook 'ruby-mode-hook 'my-ruby-mode-hook)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Markdown
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'markdown-mode-hook 'pandoc-mode)

'(markdown-css-paths
   (list "/Users/agschwender/Tools/markdown/github-markdown.css"))
'(markdown-latex-command "pandoc -V geometry:margin=1in -s --mathjax -t latex")
'(markdown-pandoc-pdf-command "pandoc -V geometry:margin=1in -s --mathjax")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Theme
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (load-theme 'sanityinc-tomorrow-eighties t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(beacon-color "#f2777a")
 '(compilation-message-face 'default)
 '(cua-global-mark-cursor-color "#2aa198")
 '(cua-normal-cursor-color "#839496")
 '(cua-overwrite-cursor-color "#b58900")
 '(cua-read-only-cursor-color "#859900")
 '(custom-safe-themes
   '("9be1d34d961a40d94ef94d0d08a364c3d27201f3c98c9d38e36f10588469ea57" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "b8929cff63ffc759e436b0f0575d15a8ad7658932f4b2c99415f3dde09b32e97" "1d079355c721b517fdc9891f0fda927fe3f87288f2e6cc3b8566655a64ca5453" "760ce657e710a77bcf6df51d97e51aae2ee7db1fba21bbad07aab0fa0f42f834" "34ed3e2fa4a1cb2ce7400c7f1a6c8f12931d8021435bad841fdc1192bd1cc7da" "b3bcf1b12ef2a7606c7697d71b934ca0bdd495d52f901e73ce008c4c9825a3aa" "cc71cf67745d023dd2e81f69172888e5e9298a80a2684cbf6d340973dd0e9b75" "25c06a000382b6239999582dfa2b81cc0649f3897b394a75ad5a670329600b45" "aea30125ef2e48831f46695418677b9d676c3babf43959c8e978c0ad672a7329" default))
 '(fci-rule-color "#515151")
 '(flycheck-color-mode-line-face-to-color 'mode-line-buffer-id)
 '(frame-background-mode 'dark)
 '(magit-diff-use-overlays nil)
 '(package-selected-packages
   '(magit base16-theme color-theme-wombat flycheck-golangci-lint coffee-mode ruby-additional color-theme-sanityinc-solarized color-theme-sanityinc-tomorrow jsx-mode exec-path-from-shell))
 '(shell-file-name "/bin/bash")
 '(smartrep-mode-line-active-bg (solarized-color-blend "#859900" "#073642" 0.2))
 '(term-default-bg-color "#002b36")
 '(term-default-fg-color "#839496")
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   '((20 . "#f2777a")
     (40 . "#f99157")
     (60 . "#ffcc66")
     (80 . "#99cc99")
     (100 . "#66cccc")
     (120 . "#6699cc")
     (140 . "#cc99cc")
     (160 . "#f2777a")
     (180 . "#f99157")
     (200 . "#ffcc66")
     (220 . "#99cc99")
     (240 . "#66cccc")
     (260 . "#6699cc")
     (280 . "#cc99cc")
     (300 . "#f2777a")
     (320 . "#f99157")
     (340 . "#ffcc66")
     (360 . "#99cc99")))
 '(vc-annotate-very-old-color nil)
 '(weechat-color-list
   '(unspecified "#002b36" "#073642" "#990A1B" "#dc322f" "#546E00" "#859900" "#7B6000" "#b58900" "#00629D" "#268bd2" "#93115C" "#d33682" "#00736F" "#2aa198" "#839496" "#657b83"))
 '(window-divider-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
