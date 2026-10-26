#!/bin/sh
# Run the Ruby tests against spec/vectors.tsv.
set -e
cd "$(dirname "$0")/../.."
. languages/lib.sh
run_tool ruby ruby:3.3.10-alpine sh -c 'cd languages/ruby && ruby -Ilib test/test_vectors.rb'
