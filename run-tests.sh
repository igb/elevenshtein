emacs --batch -L lisp/ -L tests/ -l tests/elevenshtein-tests.el -f ert-run-tests-batch-and-exit
cargo test
