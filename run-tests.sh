#!/usr/bin/env bash

set -o pipefail

fail=0


mkdir -p tests/reports
export EMACS_TEST_JUNIT_REPORT=test-report.xml;


# --- Emacs tests ---

if [ "$CI" = "true" ] || [ "$RUN_SLOW_TESTS" = "true" ]; then
    emacs --batch -L lisp/ -L tests/ -l tests/elevenshtein-tests.el -f ert-run-tests-batch-and-exit
else
    emacs --batch -L lisp/ -L tests/ -l tests/elevenshtein-tests.el  -eval "(ert-run-tests-batch-and-exit '(not (tag :slow)))"
fi



# --- Cargo tests (capture cargo status even though we pipe to xmllint) ---
cd native; cargo +nightly test  --release -- -Z unstable-options --report-time --format junit | xmllint --format - > elevenshtein-tests-cargo-release.xml
cargo_rc=${PIPESTATUS[0]}
cd ../

if [ "$cargo_rc" -ne 0 ]; then
  fail=1
fi


# --- Merge XMLs (still run this no matter what) ---

echo '<?xml version="1.0"?><testsuites>' > tests/test-report.xml
for f in native/elevenshtein-tests-cargo-release.xml tests/elevenshtein-tests.xml; do
  xmllint --xpath '//*[local-name()="testsuite"]' "$f" >> tests/test-report.xml
done
echo '</testsuites>' >> tests/test-report.xml

cp tests/test-report.xml "tests/reports/test-report-$(date +%Y-%m-%d-%H%M%S).xml"

exit "$fail"
