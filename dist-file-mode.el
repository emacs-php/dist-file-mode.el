;;; dist-file-mode.el --- Dispatch major mode for *.dist files  -*- lexical-binding: t; -*-

;; Copyright (C) 2018  Friends of Emacs-PHP development

;; Author: USAMI Kenta <tadsan@zonu.me>
;; Created: 13 Jun 2018
;; Version: 0.9.0
;; Keywords: files, convenience
;; Homepage: https://github.com/emacs-php/dist-file-mode.el
;; Package-Requires: ((emacs "24") (cl-lib "0.5") (s "1.9.0"))
;; License: GPL-3.0-or-later

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; There are sometimes files whose file name ends with `.dist'.
;; (The suffix means "distributed".)
;;
;; For example: `phpunit.xml.dist', `phpstan.neon.dist'
;;
;; This command removes `.dist' from file name and choises the appropriate major mode.

;;; Code:
(require 'rx)
(require 's)

(defvar dist-file-suffixes
  '(".dist"))

(defun dist-file-canonical-filename (filename)
  "Return `FILENAME' without `.dist' suffix."
  (cl-loop for suffix in dist-file-suffixes
           if (s-ends-with? suffix filename)
           return (replace-regexp-in-string
                   (eval `(rx ,suffix string-end)) "" buffer-file-name)
           finally return filename))

(defun dist-file-match-major-mode (filename)
  "Return `major-mode' function by `FILENAME'."
  (let ((file (dist-file-canonical-filename filename)))
    (assoc-default file auto-mode-alist #'string-match)))

;;;###autoload
(defun dist-file-mode ()
  "Execute `major-mode' for `.dist' suffixed file."
  (interactive)
  (when buffer-file-name
    (let ((mode (dist-file-match-major-mode buffer-file-name)))
      (when mode
        (funcall mode)))))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.dist" . dist-file-mode))

(provide 'dist-file-mode)
;;; dist-file-mode.el ends here
