;;
;; init.el
;;

;; proxy.elというファイルがあれば読み込む
(setq my/proxy-config-file (locate-user-emacs-file "proxy.el"))
(if (file-exists-p my/proxy-config-file)
    (load my/proxy-config-file))

;; 言語
(set-language-environment 'Japanese)

;; encoding
(set-default-coding-systems 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; パッケージ管理
(require 'package)
(add-to-list 'package-archives '("melpa" .
                                 "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" .
                                 "https://stable.melpa.org/packages/"))
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(require 'use-package)
(setq use-package-always-ensure t)

;; Paren settings
(show-paren-mode t)
;; (electric-pair-mode t)
(global-font-lock-mode t)

;; ファイル名を含む補完時に大文字・小文字を無視
(setq completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)
(setq read-buffer-completion-ignore-case t)

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
(setq-default tab-width 4)
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

;; .#* のようなバックアップファイルを作らない
(setq auto-save-default nil)

;;; バックアップファイルを作らない
(setq backup-inhibited t)

;;; 終了時にオートセーブファイルを消す
(setq delete-auto-save-files t)

;; 変更されたファイルを自動で再読み込みする
(global-auto-revert-mode 1)

(set-face-attribute 'default nil
                    :family "Cascadia Mono"
                    ;; :family "JetBrains Mono"
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

;; ネイティブコンパイルの警告を非表示にする
(setq native-comp-async-report-warnings-errors nil)

;; Helm
(use-package helm
  :bind (("C-x C-b" . helm-for-files)
         ("M-y" . helm-show-kill-ring)))

;; magit
(use-package magit
  :bind (("C-x g" . magit-status)
         ("C-c g" . magit-dispatch)
         ("C-c f" . magit-file-dispatch))
  :config
  (setq magit-section-initial-visibility-alist '((untracked . show))))

;; lsp-mode
(use-package lsp-mode
  :ensure t
  :init
  (setq lsp-keymap-prefix "C-c l")
  :commands (lsp lsp-deferred))
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024))
(setq lsp-completion-provider :capf)
(setq lsp-idle-delay 0.500)
(use-package lsp-ui :commands lsp-ui-mode)
(setq lsp-ui-imenu-enable t)
(setq lsp-headerline-breadcrumb-enable t)

;; https://github.com/typescript-language-server/typescript-language-server/issues/559
;; same definition as mentioned earlier
(advice-add 'json-parse-string :around
            (lambda (orig string &rest rest)
              (apply orig (s-replace "\\u0000" "" string)
                     rest)))
;; minor changes: saves excursion and uses search-forward instead of re-search-forward
(advice-add 'json-parse-buffer :around
            (lambda (oldfn &rest args)
	      (save-excursion
                (while (search-forward "\\u0000" nil t)
                  (replace-match "" nil t)))
		(apply oldfn args)))

;; company
(use-package company)
(add-hook 'after-init-hook 'global-company-mode)
(with-eval-after-load 'company
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 1)
  (setq company-selection-wrap-around t)
  (global-set-key (kbd "C-c <insert>") 'company-complete)
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  (define-key company-active-map (kbd "C-s") 'company-filter-candidates))

;; flycheck
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;; tree-sitterの構文定義
(setq treesit-language-source-alist
      '((java "https://github.com/tree-sitter/tree-sitter-java")
        (bash "https://github.com/tree-sitter/tree-sitter-bash")
        (hcl "https://github.com/tree-sitter-grammars/tree-sitter-hcl")
        (terraform "https://github.com/tree-sitter-grammars/tree-sitter-hcl" nil "dialects/terraform/src")
        (html "https://github.com/tree-sitter/tree-sitter-html")
        (javascript "https://github.com/tree-sitter/tree-sitter-javascript")
        (json "https://github.com/tree-sitter/tree-sitter-json")
        (typescript "https://github.com/tree-sitter/tree-sitter-typescript" nil "typescript/src")
        (tsx "https://github.com/tree-sitter/tree-sitter-typescript" nil "tsx/src")
        (go "https://github.com/tree-sitter/tree-sitter-go")
        (python "https://github.com/tree-sitter/tree-sitter-python")
        (c "https://github.com/tree-sitter/tree-sitter-c")
        (cpp "https://github.com/tree-sitter/tree-sitter-cpp")
        (c-sharp "https://github.com/tree-sitter/tree-sitter-c-sharp")
        (php "https://github.com/tree-sitter/tree-sitter-php" nil "php/src")
        ;; (perl "https://github.com/tree-sitter-perl/tree-sitter-perl")
        (rust "https://github.com/tree-sitter/tree-sitter-rust")
        (xml "https://github.com/tree-sitter-grammars/tree-sitter-xml" nil "xml/src")
        (dtd "https://github.com/tree-sitter-grammars/tree-sitter-xml" nil "dtd/src")
        (yaml "https://github.com/tree-sitter-grammars/tree-sitter-yaml")
        (toml "https://github.com/tree-sitter-grammars/tree-sitter-toml")
        (make "https://github.com/alemuller/tree-sitter-make")
        (markdown "https://github.com/tree-sitter-grammars/tree-sitter-markdown" nil "tree-sitter-markdown/src")
        (markdown-inline "https://github.com/tree-sitter-grammars/tree-sitter-markdown" nil "tree-sitter-markdown-inline/src")))

;; treesitがインストールされてない場合は自動でインストール
;;(dolist (element treesit-language-source-alist)
;;  (let ((lang (car element)))
;;    (unless (treesit-language-available-p lang)
;;      (message "treesit: installing %s" lang)
;;      (condition-case err
;;          (treesit-install-language-grammar lang)
;;        (error (message "treesit: failed to install %s: %s" lang err))))))

;; 一定期間でtree-sitterの構文定義を更新
(defun my/treesit-grammar-outdated-p (lang &optional days)
  ;; tree-sitterの文法ファイルが指定期間（日）より古ければ non-nil。"
  (let ((file (locate-file (format "libtree-sitter-%s" lang)
                           (list (expand-file-name "tree-sitter" user-emacs-directory))
                           (list ".so" ".dylib" ".dll"))))
    (or (null file)
        (> (float-time (time-since (nth 5 (file-attributes file))))
           (* (or days 7) 86400)))))

(dolist (lang (mapcar #'car treesit-language-source-alist))
  (when (my/treesit-grammar-outdated-p lang)
    (condition-case err
        (treesit-install-language-grammar lang)
      (error (message "treesit: failed to install %s: %s" lang err)))))

(defun my/update-treesit-all-grammars ()
  "登録済みの全文法を再インストールして更新する。"
  (interactive)
  (dolist (lang (mapcar #'car treesit-language-source-alist))
    (treesit-install-language-grammar lang))
  (message "treesit: update finished. Restart Emacs to apply."))

;; typescript
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))
(add-to-list 'auto-mode-alist '("\\.[cm]?ts\\'" . typescript-ts-mode))
(add-hook 'typescript-ts-mode-hook
          (lambda () (setq typescript-ts-mode-indent-offset 2)))
(require 'ansi-color)
(defun colorize-compilation-buffer ()
  (ansi-color-apply-on-region compilation-filter-start (point-max)))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)
(add-hook 'typescript-ts-mode-hook #'lsp-deferred)

;; bash
(add-to-list 'auto-mode-alist '("\\.\\(ba\\)?sh\\'" . bash-ts-mode))
;;; Bats
;;; typescript-modeのadd-to-listと競合するので、typescript-modeの定義よりも後ろに置く
(add-to-list 'auto-mode-alist '("\\.bats$" . bash-ts-mode))
(add-hook 'bash-ts-mode-hook #'lsp-deferred)

;; terraform
(add-to-list 'auto-mode-alist '("\\.tf$" . terraform-mode))
(add-hook 'terraform-mode-hook #'lsp-deferred)

;; go
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-ts-mode))
(add-hook 'go-ts-mode-hook #'lsp-deferred)

;; rust
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-ts-mode))
(add-hook 'rust-ts-mode-hook #'lsp-deferred)

;; javascript
(add-to-list 'auto-mode-alist '("\\.[cm]?jsx?$" . js-ts-mode))
(add-hook 'js-ts-mode-hook (lambda () (setq js-indent-level 2)))
(add-hook 'js-ts-mode-hook #'lsp-deferred)

;; python
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-ts-mode))
(add-hook 'python-ts-mode-hook #'lsp-deferred)

;; toml
(add-to-list 'auto-mode-alist '("\\.toml\\'" . toml-ts-mode))

;; yaml
(add-to-list 'auto-mode-alist '("\\.ya?ml\\'" . yaml-ts-mode))

; yasnippet
(use-package yasnippet)
(yas-global-mode 1)

;; dockerfile-mode
(add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))

;; csharp-mode
(add-hook 'csharp-ts-mode-hook #'lsp)

;; custom-config.elというファイルがあれば読み込む
(setq my/custom-config-file (locate-user-emacs-file "custom-config.el"))
(if (file-exists-p my/custom-config-file)
    (load my/custom-config-file))

;; インストールしたパッケージをinstalled-packages.elファイルに書き出す
(setq my/custom-file (expand-file-name "installed-packages.el" user-emacs-directory))
(when (file-exists-p my/custom-file)
  (load my/custom-file))
