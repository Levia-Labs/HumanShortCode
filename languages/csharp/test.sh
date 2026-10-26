#!/bin/sh
# Run the C# tests against spec/vectors.tsv.
set -e
cd "$(dirname "$0")/../.."
. languages/lib.sh
run_tool dotnet mcr.microsoft.com/dotnet/sdk:8.0.404 sh -c 'cd languages/csharp && DOTNET_ROLL_FORWARD=Major dotnet test tests --nologo -v q'
