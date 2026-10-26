#!/bin/sh
# Run the Rust tests against spec/vectors.tsv.
set -e
cd "$(dirname "$0")/../.."
. languages/lib.sh
run_tool cargo rust:1.90.0-slim sh -c 'cd languages/rust && CARGO_TARGET_DIR=/tmp/target cargo test --quiet'
