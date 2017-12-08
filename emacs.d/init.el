(require 'package)
(add-to-list 'package-archives
	     '("melpa-stable" . "http://melpa.org/packages/") t)
(package-initialize)


(defvar clojure-packages '(better-defaults
			   projectile
			   clojure-mode
			   cider))

(dolist (p clojure-packages)
  (unless (package-installed-p p)
    (package-install p)))

;; Add custom themes
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'dracula t)
