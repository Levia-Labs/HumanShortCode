#!/bin/sh
# Run the Go tests against spec/vectors.tsv.
set -e
cd "$(dirname "$0")/../.."
. languages/lib.sh
run_tool go golang:1.26.2-bookworm sh -c 'cd languages/go && go test ./...'
