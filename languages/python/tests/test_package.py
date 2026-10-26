import pytest
from hypothesis import given
from hypothesis import strategies as st

import human_short_code
from human_short_code import ID_CODE_ALPHABET, ID_CODE_LENGTH, decode, encode, verify

MAX_VALUE = len(ID_CODE_ALPHABET) ** ID_CODE_LENGTH - 1


def test_package_exports_api():
    for name in ("encode", "decode", "verify"):
        assert callable(getattr(human_short_code, name))


def test_known_vectors():
    assert encode(0) == "AAAA-AAAA"
    assert decode(encode(123456)) == 123456
    assert decode("QRQW-ISAA") == decode("qrqwisaa") == 987654


@pytest.mark.parametrize("number", [1, 9, 490, 999, 10000, 99999999])
def test_shape(number):
    code = encode(number)
    assert len(code) == ID_CODE_LENGTH + 1
    assert code[ID_CODE_LENGTH // 2] == "-"
    assert decode(code) == number


@given(st.integers(min_value=0, max_value=MAX_VALUE))
def test_roundtrip_and_verify(n):
    code = encode(n)
    assert decode(code) == n
    assert verify(code)


def test_verify_semantics():
    assert not verify("")
    assert verify("aaaa-aaaa")
    assert verify("AAAAAAAA")
    assert not verify("AS")
    assert not verify("AAAA-AAAAA")
    assert not verify("ZZZZ-ZZZZ")
    assert verify("AB", alphabet="AB", length=2)
    assert not verify("ABA", alphabet="AB", length=2)
