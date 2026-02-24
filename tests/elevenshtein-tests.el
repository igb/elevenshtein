;; UNIT TESTS
(require 'ert)
(require 'ert-x)
(require 'elevenshtein)



;; utility function to read a resource file into a string
(defun file-to-string (file)
  (with-temp-buffer
    (insert-file-contents (ert-resource-file file))
    (buffer-string)))

;; utility to test edit distance calculations of size n
(defun test-n-distance(n)
  (let
      ((x (file-to-string (concat "x-" (number-to-string n) ".txt")))	   
       (y (file-to-string (concat "y-" (number-to-string n) ".txt"))))
       (should
	(equal
	 (edit-distance x y)
	 n)
	)))


;; utility to test edit distance calculations of size n
(defun test-native-n-distance(n)
  (let
      ((x (file-to-string (concat "x-" (number-to-string n) ".txt")))	   
       (y (file-to-string (concat "y-" (number-to-string n) ".txt"))))
       (should
	(equal
	 (native-edit-distance x y)
	 n)
	)))



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


(ert-deftest test-edit-distance-same()
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

(ert-deftest test-empty-empty-edit-distance()
  "Ensure that zero-length-to-zero-length string  comparisons are hadled correctly."
  (should
   (equal
    (edit-distance "" "")
    0)
   ))

(ert-deftest test-non-empty-empty-edit-distance()
  "Ensure that zero-length-to-zero-length string  comparisons are nadled correctly."
  (should
   (equal
    (edit-distance "xyz" "")
    3)
   ))


(ert-deftest test-empty-non-empty-edit-distance()
  "Ensure that zero-length-to-zero-length string  comparisons are nadled correctly."
  (should
   (equal
    (edit-distance "" "abc")
    3)
   ))



(ert-deftest test-single-char-no-diff()
  "Ensure that single-char string comparisons are handled correctly."
  (should
   (equal
    (edit-distance "a" "a")
    0)
   ))


(ert-deftest test-single-char-with-diff()
  "Ensure that single-char string comparisons are handled correctly."
  (should
   (equal
    (edit-distance "a" "b")
    1)
   ))


(ert-deftest test-single-char-to-larger-string()
  "Ensure that single-char string comparisons are handled correctly."
  (should
   (equal
    (edit-distance "a" "ab")
    1)
   ))




(ert-deftest test-edit-distance-100()
  "Ensure that edit distance is calculated correctly with max delta for a 100-byte string."
  (test-n-distance 100) 
  )



(ert-deftest test-edit-distance-1000()
  "Ensure that edit distance is calculated correctly with max delta for a 1000-byte string."
  (test-n-distance 1000) 
 )


;(ert-deftest test-edit-distance-10000()
;  "Ensure that edit distance is calculated correctly with max delta for a 1000-byte string."
;  (test-n-distance 10000) 
; )


(ert-deftest test-native-edit-distance-100()
  "Ensure that edit distance is calculated correctly with max delta for a 100-byte string."
  (test-native-n-distance 100) 
  )



(ert-deftest test-native-edit-distance-1000()
  :tags '(:slow)
  "Ensure that edit distance is calculated correctly with max delta for a 1000-byte string."
  (test-native-n-distance 1000) 
 )


(ert-deftest test-native-edit-distance-10000()
  :tags '(:slow)
  "Ensure that edit distance is calculated correctly with max delta for a 1000-byte string."
  (test-native-n-distance 10000) 
 )


(ert-deftest test-edit-distance-with-unicode-hindi-nutka-diff()
      "Ensure that edit distance is calculated correctly in non-latin charcter sets"  
  (should
   (equal
    (edit-distance "जरा" "ज़रा")
    1)
   ))



(ert-deftest test-edit-distance-with-unicode-cjk-diff()
      "Ensure that edit distance is calculated correctly in non-latin character sets"  
  (should
   (equal
    (edit-distance "日本" "日本語")
    1)
   ))


(ert-deftest test-edit-distance-with-unicode-emojii-diff()
      "Ensure that edit distance is calculated correctly in non-latin character sets"  
  (should
   (equal
    (edit-distance "🤔" "😬")
    1)
   ))



(ert-deftest test-edit-distance-with-unicode-accent-diff()
      "Ensure that edit distance is calculated correctly in non-latin character sets"  
  (should
   (equal
    (edit-distance "café" "cafe")
    1)
   ))


(ert-deftest test-edit-distance-with-unicode-diacritics-diff()
      "Ensure that edit distance is calculated correctly in non-latin character sets"  
  (should
   (equal
    (edit-distance "naïve" "naive")
    1)
   ))

