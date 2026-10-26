#!/bin/sh
# Run the PHP tests against spec/vectors.tsv.
set -e
cd "$(dirname "$0")/../.."
. languages/lib.sh
run_tool php php:8.3.27-cli-alpine sh -c 'cd languages/php && php tests/vectors.php'
