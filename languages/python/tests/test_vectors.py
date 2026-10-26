import csv
from pathlib import Path

import pytest

from human_short_code import decode, encode, verify

VECTORS = Path(__file__).resolve().parents[3] / "spec" / "vectors.tsv"
OPS = {"encode": encode, "decode": decode, "verify": verify}


def _rows():
    with VECTORS.open(newline="", encoding="utf-8") as f:
        lines = (line for line in f if not line.startswith("#"))
        return list(csv.reader(lines, delimiter="\t"))


@pytest.mark.parametrize(("op", "value", "alphabet", "length", "expected"), _rows())
def test_vector(op, value, alphabet, length, expected):
    kwargs = {}
    if alphabet != "-":
        kwargs["alphabet"] = alphabet
    if length != "-":
        kwargs["length"] = int(length)
    arg = int(value) if op == "encode" else value
    if expected == "!error":
        with pytest.raises(ValueError, match=r"^human-short-code:"):
            OPS[op](arg, **kwargs)
        return
    want = {"true": True, "false": False}.get(expected, expected)
    if op == "decode":
        want = int(expected)
    assert OPS[op](arg, **kwargs) == want


@pytest.mark.parametrize("bad", [1.5, "1", None, True])
def test_encode_rejects_non_integer(bad):
    with pytest.raises(TypeError):
        encode(bad)
