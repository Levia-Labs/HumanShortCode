#!/bin/sh
# Run the Swift tests against spec/vectors.tsv.
set -e
cd "$(dirname "$0")/../.."
. languages/lib.sh
run_tool swift swift:6.0.3-jammy sh -c 'cd languages/swift && swift test --scratch-path /tmp/build'
