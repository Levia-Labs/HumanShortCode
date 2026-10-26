#!/bin/sh
# Run the TypeScript tests against spec/vectors.tsv.
set -e
cd "$(dirname "$0")/../.."
. languages/lib.sh
run_tool npm node:22.11.0-alpine sh -c 'cd languages/typescript && npm ci && npm test'
