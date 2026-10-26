"""Run as ``python -m human_short_code <number>`` to print the code for a number."""

import sys

from human_short_code import encode


def main() -> int:
    if len(sys.argv) != 2:
        sys.stderr.write("usage: python -m human_short_code <non-negative integer>\n")
        return 2
    sys.stdout.write(encode(int(sys.argv[1])) + "\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
