# Shared helper for languages/*/test.sh; source it after cd to the repository root.
#
# run_tool BINARY IMAGE COMMAND...
#   Runs COMMAND in the repository root when BINARY is installed, else inside the
#   pinned Docker IMAGE with the repository mounted at /w. Set HSC_FORCE_DOCKER=1
#   to always use Docker (CI does this to match pinned toolchain versions).
run_tool() {
  tool=$1
  image=$2
  shift 2
  if [ -z "${HSC_FORCE_DOCKER:-}" ] && command -v "$tool" >/dev/null 2>&1; then
    "$@"
  else
    # pwd -W gives a Windows path under Git Bash; MSYS_NO_PATHCONV stops /w being rewritten.
    root=$(pwd -W 2>/dev/null || pwd)
    MSYS_NO_PATHCONV=1 docker run --rm -v "$root:/w" -w /w "$image" "$@"
  fi
}
