(defun setRegister (val targetRegister registers)
    (let ((idx -1))
        (mapcar #'(lambda (x)
            (incf idx)
            (if (= idx targetRegister) val x))
            registers
        )
    )
)
(defun simpleOp 
    (f lhs rhs targetRegister registers)
    (setRegister (funcall f lhs rhs) targetRegister registers)
)
(defun comparisonOp 
    (comp lhs rhs targetRegister registers)
    (setRegister (if (funcall comp lhs rhs) 1 0) targetRegister registers)
)

(defun addr (A B C registers)
    (simpleOp '+ (nth A registers) (nth B registers) C registers)
)
(defun addi (A B C registers)
    (simpleOp '+ (nth A registers) B C registers)
)
(defun mulr (A B C registers)
    (simpleOp '* (nth A registers) (nth B registers) C registers)
)
(defun muli (A B C registers)
    (simpleOp '* (nth A registers) B C registers)
)
(defun banr (A B C registers)
    (simpleOp 'logand (nth A registers) (nth B registers) C registers)
)
(defun bani (A B C registers)
    (simpleOp 'logand (nth A registers) B C registers)
)
(defun borr (A B C registers)
    (simpleOp 'logior (nth A registers) (nth B registers) C registers)
)
(defun bori (A B C registers)
    (simpleOp 'logior (nth A registers) B C registers)
)
(defun setr (A B C registers)
    (simpleOp '+ (nth A registers) 0 C registers)
)
(defun seti (A B C registers)
    (simpleOp '+ A 0 C registers)
)
(defun gtir (A B C registers)
    (comparisonOp '> A (nth B registers) C registers)
)
(defun gtri (A B C registers)
    (comparisonOp '> (nth A registers) B C registers)
)
(defun gtrr (A B C registers)
    (comparisonOp '> (nth A registers) (nth B registers) C registers)
)
(defun eqir (A B C registers)
    (comparisonOp '= A (nth B registers) C registers)
)
(defun eqri (A B C registers)
    (comparisonOp '= (nth A registers) B C registers)
)
(defun eqrr (A B C registers)
    (comparisonOp '= (nth A registers) (nth B registers) C registers)
)
(defun same (l1 l2)
    (and (= (length l1) (length l2))
        (reduce #'(lambda (l r) (and l r))
            (mapcar #'(lambda (l r) (= l r)) l1 l2))
    )
)

(defun works (opfn A B C before target)
    (let ((after (funcall opfn A B C before)))
        (same target after)
    )
)

(defun getWorking (A B C before target opfns)
    (remove-if #'(lambda (opfn) (not(works opfn A B C before target))) opfns)
)

(defun stripNonDigits (line)
    (remove-if 
        #'(lambda (c) (not (member c '(#\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9 #\Space))))
        line
    )
)

(defun asIntList (line)
    (read-from-string (concatenate 'string "(" line ")"))
)

(defun getstate (line)
    (asIntList (stripNonDigits line))
)

(defun getOp (line)
    (asIntList line)
)

(defun safesubs (l s e)
    (if (or (> e (length l)) (> s (length l))) "" (subseq l s e))
)

(defun getWorkingFromSamples (input)
    (loop for line = (read-line input nil) until (null line)
        collect  (if (string= (safesubs line 0 6) "Before")
            (let* ((before (getstate line))
                    (op (getop (read-line)))
                    (after (getstate (read-line)))
                    (unused (read-line)))
                (getWorking (nth 1 op) (nth 2 op) (nth 3 op) before after '(
                    addi
                    addr
                    muli
                    mulr
                    seti
                    setr
                    bani
                    banr
                    bori
                    borr
                    eqrr
                    eqri
                    eqir
                    gtrr
                    gtri
                    gtir
                ))
            )
            '()
        )
    )
)

(print (length (remove-if #'(lambda (w) (<= (length w) 2)) (getWorkingFromSamples *standard-input*))))
