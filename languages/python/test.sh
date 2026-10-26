#!/bin/sh
# Run the Python tests against spec/vectors.tsv.
set -e
cd "$(dirname "$0")/../.."
. languages/lib.sh
# Container venv in /tmp: a Linux .venv in the host tree breaks later host runs.
HSC_DOCKER_ARGS="-e UV_PROJECT_ENVIRONMENT=/tmp/venv"
run_tool uv ghcr.io/astral-sh/uv:0.9.5-python3.12-bookworm-slim sh -c 'cd languages/python && uv run pytest -q'
