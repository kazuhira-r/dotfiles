;;
;; init.el
;;
(setq proxy-config-file (locate-user-emacs-file "~/.emacs.d/proxy.el"))
(if (file-exists-p proxy-config-file)
    (load proxy-config-file))

;; Language.
(set-language-environment 'Japanese)

;; Coding system.
(set-default-coding-systems 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; Package Manegement
(require 'package)
(add-to-list 'package-archives '("melpa" .
                                 "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" .
                                 "https://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("marmalade" .
                                 "https://marmalade-repo.org/packages/"))
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

;; Paren settings
(show-paren-mode t)
;; (electric-pair-mode t)
(global-font-lock-mode t)

;; Ignore case
(setq completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; [基本] 背景色・透過
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 背景色設定
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background "#000000" :foreground "#EEEEEE")))))
;; '(cursor (
;;           (((class color) (background dark )) (:background "#00AA00"))
;;           (((class color) (background light)) (:background "#999999"))
;;           (t ())
;;           )))
;; フレーム透過設定
;;(add-to-list 'default-frame-alist '(alpha . (0.75 0.75)))

;; TABの表示幅(初期値8から4に変更)
(setq default-tab-width 4)
(setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72
                        76 80 84 88 92 96 100 104 108 112 116 120 124 128
                        132 136 140 144
                        148 152 156 160 164 168 172 176 180 184 188 192
                        196 200 204 208 212 216))

;; TABでなくスペースを使う
(setq-default indent-tabs-mode nil)

;; スタートアップメッセージ非表示
(setq inhibit-startup-screen t)

;; tool-bar
;; (tool-bar-mode 0)

;; menu-bar
(menu-bar-mode 0)

;; 言語設定
(set-coding-system-priority 'utf-8 'euc-jp 'iso-2022-jp 'cp932)

;; 現在行に色をつける
(global-hl-line-mode 1)

;; リージョンに色をつける
(transient-mark-mode 1)

;; 行番号、桁番号を表示する
(line-number-mode 1)
(column-number-mode 1)

;; 同名ファイルのバッファ名の識別文字列を変更する
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;; .#* とかのバックアップファイルを作らない
(setq auto-save-default nil)

;;; バックアップファイルを作らない
(setq backup-inhibited t)

;;; 終了時にオートセーブファイルを消す
(setq delete-auto-save-files t)

;; 変更されたファイルの自動再読み込み
(global-auto-revert-mode 1)

(set-face-attribute 'default nil
                    :family "MS ゴシック"
                    :height 105)

;;; フレームパラメータ初期値の設定
(setq default-frame-alist
      (append (list
               ;; サイズ
               '(width . 220)  ; 横幅(桁数)
               '(height . 60) ; 高さ(行数)
               ;; 位置
               '(left . 10) ; 左上隅 x 座標
               '(top . 5)  ; 左上隅 y 座標
               ;; 背景と文字の色
               ;;               '(background-color . "white")
               ;;               '(foreground-color . "black")
               ;; スクロールバー
               '(vertical-scroll-bars . right)
               ;; カーソル
               ;;               '(cursor-type . box)      ; 種類
               ;;               '(cursor-height . 4)      ; 高さ
               ;;               '(cursor-color . "black") ; 色
               ;; フォント
                                        ;              '(font . "default-fontset")
                                        ;              '(ime-font . "default-japanese-jisx0208")
               )
              default-frame-alist))

;; cua-modeの設定
(cua-mode t)  ; cua-modeをオン
(setq cua-enable-cua-keys nil)  ; CUAキーバインドを無効化

;; dired
(put 'dired-find-alternate-file 'disabled nil)

;; 手動で導入したelispのインストールディレクトリ
(defconst my-elisp-directory "~/.emacs.d/elisp/" "The directory for myelisp file.")
(dolist (dir (let ((dir (expand-file-name my-elisp-directory)))
               (list dir (format "%s%d" dir emacs-major-version))))
  (when (and (stringp dir) (file-directory-p dir))
    (let ((default-directory dir))
      (add-to-list 'load-path default-directory)
      (normal-top-level-add-subdirs-to-load-path))))

;; recentf-ext
;;(require 'recentf-ext)

;; Helm
(require 'helm-config)
(define-key global-map (kbd "C-x C-b") 'helm-for-files)
(define-key global-map (kbd "M-y") 'helm-show-kill-ring)

;; lsp-mode
(require 'lsp-mode)
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024))
(setq lsp-completion-provider :capf)
(setq lsp-idle-delay 0.500)
(require 'lsp-ui)
(setq lsp-ui-imenu-enable t)
(setq lsp-headerline-breadcrumb-enable t)

;; company
(require 'company)
(global-company-mode t)
(setq company-idle-delay 0)
(setq company-minimum-prefix-length 1)
(setq company-selection-wrap-around t)
(setq completion-ignore-case t)
(define-key company-active-map (kbd "C-n") 'company-select-next)
(define-key company-active-map (kbd "C-p") 'company-select-previous)
(define-key company-active-map (kbd "C-s") 'company-filter-candidates)

;; go
(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook (go-mode . lsp-deferred))
;(require 'company-go)
;(add-hook 'go-mode-hook (lambda ()
;                          (set (make-local-variable 'company-backends) '(company-go))
;                          (company-mode)))

;; python
;(require 'lsp-pyright)
;(add-hook 'python-mode-hook #'lsp)

;; groovy-mode
(autoload 'groovy-mode "groovy-mode" "Groovy editing mode." t)
(add-to-list 'auto-mode-alist '("\.groovy$" . groovy-mode))
(add-to-list 'auto-mode-alist '("\.gradle$" . groovy-mode))
(add-to-list 'interpreter-mode-alist '("groovy" . groovy-mode))

;; scala-mode
(require 'scala-mode)
(add-to-list 'auto-mode-alist '("\.sbt$" . scala-mode))

; yasnippet
(require 'yasnippet)
(yas/global-mode 1)

;; auto-complete
;;(require 'auto-complete)
;;(global-auto-complete-mode t)
;;(define-key ac-complete-mode-map "\C-n" 'ac-next)
;;(define-key ac-complete-mode-map "\C-p" 'ac-previous)

;;;; auto-java-complete
;;(require 'ajc-java-complete-config)
;;(add-hook 'java-mode-hook 'ajc-java-complete-mode)

;; dockerfile-mode
(require 'dockerfile-mode)
(add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))

;; js2-mode
(require 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;; csharp-mode
(require 'lsp-mode)
(add-hook 'csharp-mode-hook #'lsp)

;; custom
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))
