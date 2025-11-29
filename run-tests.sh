mkdir -p tests
export EMACS_TEST_JUNIT_REPORT=test-report.xml;
emacs --batch -L lisp/ -L tests/ -l tests/elevenshtein-tests.el -f ert-run-tests-batch-and-exit
cd native; cargo +nightly test  --release -- -Z unstable-options --report-time --format junit | xmllint --format - > elevenshtein-tests-cargo-release.xml
cd ../
echo '<?xml version="1.0"?><testsuites>' > tests/test-report.xml
for f in native/elevenshtein-tests-cargo-release.xml tests/elevenshtein-tests.xml; do
  xmllint --xpath '//*[local-name()="testsuite"]' "$f" >> tests/test-report.xml
done
echo '</testsuites>' >> tests/test-report.xml

cp tests/test-report.xml "tests/reports/test-report-$(date +%Y-%m-%d-%H%M%S).xml"

