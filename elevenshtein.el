;;; elevenshtein.el --- Tiny demo math helpers  -*- lexical-binding: t; -*-

;; Author: Ian Brown <igb@hccp.org>
;; URL:    https://github.com/igb/elevenshtein
;; Package-Requires: ((emacs "29.3"))
;; License: MIT

;;; Commentary:

;; An edit distance implementation for comparing two buffers.

;;; Code:

(defun edit-distance-buf ()
  (interactive)
  (let* (
	 (SourceBuffer (read-buffer "Select first buffer to compare: "))
	 (SourceStr (get-buffer-as-string SourceBuffer))
	 (TargetBuffer (read-buffer "Select second buffer to compare: "))
	 (TargetStr (get-buffer-as-string TargetBuffer))
	 )
    (message "calculating edit distance...")
    (message "Edit distance is %s" (edit-distance SourceStr TargetStr))
    )
  )

(defun get-buffer-as-string (Buffer)
  (with-current-buffer Buffer
  (buffer-substring-no-properties (point-min) (point-max))))



(defun edit-distance (Source Target)
  (let (
	(matrix (init-matrix Source Target))
	(SourceLength (length Source))
	(TargetLength (length Target))
	)

    (dotimes (_i SourceLength)
      (dotimes (_j TargetLength)
	(let ( (i (+ _i 1))
	       (j (+ _j 1))
	       )

	  (let* (
		(cost
		 (if (= (aref Source  (- i 1)) (aref Target  (- j 1) ))
		     0
		   1)
		 )
		(deletion
		 (+ (get-cell (- i 1) j (+ SourceLength 1) (+ TargetLength 1) matrix) 1))
		(insertion
		 (+ (get-cell i (- j 1) (+ SourceLength 1) (+ TargetLength 1) matrix) 1))
	       	(substitution
		 (+ (get-cell (- i 1) (- j 1) (+ SourceLength 1) (+ TargetLength 1) matrix) cost))
		(distance (min deletion insertion substitution))
		)

	    (set-cell i j distance (+ SourceLength 1) (+ TargetLength 1) matrix)
	    
	    )
	  

	  )
	)
      )
 (get-cell SourceLength TargetLength (+ SourceLength 1) (+ TargetLength 1) matrix ) ))

;; create the 2D array that stores the edit distance calculations.
(defun init-matrix (Source Target) 
  (let* ( ;; using let* to ensure the sequential binding of variables
	 (rows (+ (length Source) 1))
	 (cols (+ (length Target) 1))
	 (matrix (make-vector (* rows cols) 0)))
    
    ;; set the top row costs to 0, 1, 2 ...source length
    (dotimes (i cols)
      (set-cell 0 i i rows cols matrix))
    
    ;; set the first col costs to 0, 1, 2 ...target length
    (dotimes (j rows)
      (set-cell j 0 j rows cols matrix))
    
    matrix))


;;this has a side effect, should refactor away
(defun set-cell (row column value rows cols matrix)
  (aset matrix (+ (* row cols) column) value)
  matrix)

(defun get-cell (row column rows cols matrix)
  (aref matrix (+ (* row cols) column)))


(provide 'elevenshtein)
;;; elevenshtein.el ends here
