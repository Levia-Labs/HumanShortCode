#!/bin/sh
# Compile and run the Java vector test against spec/vectors.tsv.
set -e
cd "$(dirname "$0")/../.."
. languages/lib.sh
run_tool javac eclipse-temurin:21.0.5_11-jdk sh -c 'out=$(mktemp -d) && javac -d "$out" languages/java/*.java && java -cp "$out" VectorsTest'
