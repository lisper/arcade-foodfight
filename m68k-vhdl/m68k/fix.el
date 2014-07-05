;;
(defun fix-op ()
""
(interactive)
  (search-forward "op_i == ")
  (upcase-word 1))

(defun fix-op1 ()
""
(interactive)
  (search-forward "op_i = ")
  (upcase-word 1))

(defun fix-op2 ()
""
(interactive)
  (search-forward "op == ")
  (upcase-word 1))

(defun fix-op3 ()
""
(interactive)
  (search-forward "op==")
  (upcase-word 1))

(defun fix-exec1 ()
""
(interactive)
  (search-forward "exec_state == ")
  (upcase-word 1))

(defun fix-exec2 ()
""
(interactive)
  (search-forward "exec_state <= ")
  (upcase-word 1))

(defun fix-paren ()
""
(interactive)
  (query-replace-regexp "[()]" ""))


(define-key global-map [f13] 'fix-op)
(define-key global-map [f13] 'fix-op1)
(define-key global-map [f14] 'fix-paren)
(define-key global-map [f13] 'fix-op2)
(define-key global-map [f4] 'fix-op2)
(define-key global-map [f4] 'fix-op3)
(define-key global-map [f4] 'fix-exec1)
(define-key global-map [f4] 'fix-exec2)

(defun fix-paren ()
""
(interactive)
(save-excursion
  (query-replace-regexp "(op_i == \\(\\w*\\))"
			"op_i == \\1")
))

(defun fix-if ()
""
(interactive)
(save-excursion
  (query-replace-regexp "!(\\(.*?\\)==\\(.*?\\))"
			"\\1 != \\2")
))

(define-key global-map [f4] 'fix-paren)
(define-key global-map [f15] 'fix-if)


(defun fix-dparen ()
  ""
  (interactive)
  (save-excursion
    (query-replace-regexp "((\\(.*\\)))"
			  "(\\1)")
    ))

(define-key global-map [f4] 'fix-dparen)

(defun fix-paren2 ()
  ""
  (interactive)
  (save-excursion
    (query-replace-regexp "((\\(.*?\\)) & (\\(.*?\\))"
			  "(\\1 & \\2")
    ))

(define-key global-map [f4] 'fix-paren2)

(defun fix-paren3 ()
  ""
  (interactive)
  (save-excursion
    (query-replace-regexp "((\\(.*?\\)) | (\\(.*?\\))"
			  "(\\1 | \\2")
    ))

(define-key global-map [f4] 'fix-paren3)

(defun fix-paren4 ()
  ""
  (interactive)
  (save-excursion
    (query-replace-regexp "(\\(.*?\\) == 1'b1)"
			  "\\1")
    ))
(define-key global-map [f13] 'fix-paren4)

byte__op_sizetype BYTE
word__op_sizetype WORD
long__op_sizetype LONG

(defun fix-case ()
  ""
  (interactive)
  (progn
    (search-forward "?")
    (move-end-of-line 1)
    (delete-char 1 t)
    (just-one-space)
    (move-end-of-line 1)
    (insert " :")))

(define-key global-map [f4] 'fix-case)

(defun fix-case2 ()
""
(interactive)
(save-excursion
  (query-replace-regexp "\\(^[ ]*\\): \\(.*\\) [?]+ \\(.*\\)$"
			"\\1\\2 ? \\3 :")
))


(define-key global-map [f15] 'fix-case2)
