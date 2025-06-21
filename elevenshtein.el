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

;; UNIT TESTS
(require 'ert)

(ert-deftest test-set-cell()
  "Validate that set cell operations work on a valid matrix"
  (should
   (equal
    [0 1 0 0]
    (set-cell 0 1 1 2 2 [0 0 0 0])
    )
   )
  
  (should
   (equal
    [0 0 1 0]
    (set-cell 1 0 1 2 2 [0 0 0 0])
    )
   )

  
  (should
   (equal
     [0 1 2 1 0 0 0 0 0]
    (set-cell 1 0 1 3 3  [0 1 2 0 0 0 0 0 0])
    )
   )

  
  (should
   (equal
     [0 1 2 1 0 0 2 0 0]
    (set-cell 2 0 2 3 3  [0 1 2 1 0 0 0 0 0])
    )
   )
  
  )



(ert-deftest test-get-cell()
  "Validate that get cell operations work on a valid matrix"
  (should
   (equal
    1
    (get-cell 0 1 2 2 [0 1 0 0])
    )
   )

   (should
   (equal
    45
    (get-cell 2 2 3 3 [0 0 0 0 0 0 0 0 45])
    )
   )
)

(ert-deftest test-matrix-creation()
  "Validate that the correct vector representation of a matrix is created."
  (should
   (equal
   (init-matrix "AB" "ZY")
   [0 1 2 1 0 0 2 0 0])
   ))


(ert-deftest test-edit-distance-0()
  "Validate that two identical strings have an edit distance of '0'."
  (should
   (equal
   (edit-distance "This should be the same." "This should be the same.")
   0)
   ))

(ert-deftest test-edit-distance-diff-lengths()
  "Ensure that edit distance is calculated correctly when strings are of different lengths."
  (should
   (equal
   (edit-distance "This is a short string." "This is a much, much, much, longer string.")
   22)
   ))



(ert-deftest test-edit-distance-diff-lengths-order()
  "Ensure that edit distance is calculated correctly when strings are of different lengths."
  (should
   (equal
   (edit-distance "This is a much, much, much, longer string." "This is a short string.")
   22)
   ))


(ert-deftest test-edit-distance-basic()
  "Ensure that edit distance is calculated correctly when strings are of different lengths."
  (should
   (equal
   (edit-distance "kitten" "sitting")
   3)
   ))



