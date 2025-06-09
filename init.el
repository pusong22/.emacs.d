;; UTF-8 as default encoding
(when (eq system-type 'windows-nt)
  (set-language-environment 'Chinese-GBK)
  (set-default-coding-systems 'utf-8-unix)
  )

;; open init.el
(defun open-init-file()
  (interactive)
  (find-file user-init-file))

(global-set-key (kbd "<f2>") #'open-init-file)


;; package
(require 'package)
(setq package-archives '(("gnu"    . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("nongnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
                         ("melpa"  . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))

;; apperance
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

(setq inhibit-startup-screen -1)
(setq inhibit-startup-message -1)
(setq visible-bell 1)
(setq ring-bell-function 'ignore)

(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)
(global-hl-line-mode 1)
(line-number-mode 1)



;; load theme
(load-theme 'modus-vivendi)

;; font
(when (display-graphic-p)
  (set-frame-font (font-spec :family "JetBrains Mono Regular" :size 14))
  (dolist (script '(han cjk-misc bopomofo))
    (set-fontset-font
     (frame-parameter nil 'font)
     script
     (font-spec :family "Microsoft YaHei UI Regular" :size 14))))

;; custome file
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file)

;;
(require 'server)
(unless (server-running-p)
  (server-start))

;;
(setq delete-by-moving-to-trash t)



;; code style
(setq tab-width 4)
(setq indent-tabs-mode nil)

;; python


(defvar my/python-venv-root nil
  "Path to the current Python virtualenv root.")

(defvar my/python-venv-change-hook nil
  "Hook run after `my/set-python-venv` is called.")


(defun my/set-python-venv (venv-path)
  "Set `my/python-venv-root` and `python-shell-virtualenv-root`, and restart Python shell if running."
  (interactive "DPath to virtualenv: ")
  (setq my/python-venv-root venv-path)
  (when venv-path
    (setq python-shell-virtualenv-root venv-path)
    (message "Python virtualenv set to: %s" venv-path)
    (run-hooks 'my/python-venv-change-hook)))

(defun my/run-python ()
  "Run current Python file using compilation-mode with virtualenv support."
  (interactive)
  (save-buffer)
  (let* ((file (buffer-file-name))
         (python
          (if my/python-venv-root
                (expand-file-name "Scripts/python" my/python-venv-root)
            (executable-find python-shell-interpreter)))
         (cmd (format "%s %s" (shell-quote-argument python) (shell-quote-argument file))))
    (message "Running: %s" cmd)
    (compilation-start cmd 'compilation-mode)))

(progn
  (require 'python)
  (define-key python-mode-map (kbd "C-c r") #'my/run-python))

(defun my/python-file-header ()
  "Insert  python file header. "
  (when (and (string= (file-name-extension (or (buffer-file-name) "")) "py")
             (= (point-max) 1))
    (insert
     (format "# _*_ coding: utf-8 _*_ \n"))))

(add-hook 'find-file-hook 'my/python-file-header)
