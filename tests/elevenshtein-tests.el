;; UNIT TESTS
(require 'ert)
(require 'elevenshtein)

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



