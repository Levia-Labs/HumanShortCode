#!/bin/sh
# Run the JavaScript tests against spec/vectors.tsv.
set -e
cd "$(dirname "$0")/../.."
. languages/lib.sh
run_tool node node:22.11.0-alpine sh -c 'cd languages/javascript && node --test'
