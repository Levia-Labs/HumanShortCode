#!/bin/sh
# Run the Dart tests against spec/vectors.tsv.
set -e
cd "$(dirname "$0")/../.."
. languages/lib.sh
run_tool dart dart:3.6.0 sh -c 'cd languages/dart && dart pub get && dart test'
