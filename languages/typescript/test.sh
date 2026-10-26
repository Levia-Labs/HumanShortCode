#!/bin/sh
# Run the TypeScript tests against spec/vectors.tsv.
set -e
cd "$(dirname "$0")/../.."
. languages/lib.sh
# Anonymous volume: Docker installs Linux node_modules there, not in the host tree.
HSC_DOCKER_ARGS="-v /w/languages/typescript/node_modules"
run_tool npm node:22.11.0-alpine sh -c 'cd languages/typescript && npm ci && npm test'
