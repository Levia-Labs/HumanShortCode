#!/bin/sh
# Run the Kotlin tests against spec/vectors.tsv.
set -e
cd "$(dirname "$0")/../.."
. languages/lib.sh
run_tool gradle gradle:8.10.2-jdk21 sh -c 'cd languages/kotlin && gradle test --no-daemon -q'
