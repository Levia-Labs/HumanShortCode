# Shared helper for languages/*/test.sh; source it after cd to the repository root.
#
# run_tool BINARY IMAGE COMMAND...
#   Runs COMMAND in the repository root when BINARY is installed, else inside the
#   pinned Docker IMAGE with the repository mounted at /w. Set HSC_FORCE_DOCKER=1
#   to always use Docker (CI does this to match pinned toolchain versions).
#   HSC_DOCKER_ARGS adds docker run options; test.sh uses it to keep Linux-built
#   dependencies (node_modules, .venv) out of the host tree, where a later host
#   run would pick them up and fail.
run_tool() {
  tool=$1
  image=$2
  shift 2
  if [ -z "${HSC_FORCE_DOCKER:-}" ] && command -v "$tool" >/dev/null 2>&1; then
    "$@"
  else
    # pwd -W gives a Windows path under Git Bash; MSYS_NO_PATHCONV stops /w being rewritten.
    root=$(pwd -W 2>/dev/null || pwd)
    # HSC_DOCKER_ARGS is unquoted on purpose: it holds several options.
    # shellcheck disable=SC2086
    MSYS_NO_PATHCONV=1 docker run --rm -v "$root:/w" -w /w ${HSC_DOCKER_ARGS:-} "$image" "$@"
  fi
}
