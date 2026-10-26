"""HumanShortCode: encode and decode integer IDs into short, human-readable strings."""

from human_short_code._core import (
    ID_CODE_ALPHABET,
    ID_CODE_LENGTH,
    decode,
    encode,
    verify,
)

__all__ = ["ID_CODE_ALPHABET", "ID_CODE_LENGTH", "decode", "encode", "verify"]
