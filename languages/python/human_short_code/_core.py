"""Human Short Code reference implementation of spec/SPEC.md."""

ID_CODE_ALPHABET = "ASDEIUNWRQXBOKH"
ID_CODE_LENGTH = 8


def _check_config(alphabet, length):
    if type(length) is not int:
        raise TypeError("human-short-code: length must be an integer")
    alphabet = alphabet.upper()
    if len(alphabet) < 2 or len(set(alphabet)) != len(alphabet) or length < 1:
        raise ValueError("human-short-code: alphabet needs 2+ unique characters and length 1+")
    size = 1
    for _ in range(length):
        if (size := size * len(alphabet)) > 2**53:
            raise ValueError("human-short-code: alphabet and length exceed the safe integer range")
    return alphabet


def encode(id_number, alphabet=ID_CODE_ALPHABET, length=ID_CODE_LENGTH):
    """Encode a non-negative integer as a code such as ``QRQW-ISAA``."""
    alphabet = _check_config(alphabet, length)
    if isinstance(id_number, bool) or not isinstance(id_number, int):
        raise TypeError("human-short-code: id must be an integer")
    if not 0 <= id_number < len(alphabet) ** length:
        raise ValueError("human-short-code: id out of range")
    digits = []
    for _ in range(length):
        id_number, digit = divmod(id_number, len(alphabet))
        digits.append(alphabet[digit])
    half = length // 2
    return "".join(digits[:half]) + ("-" if half else "") + "".join(digits[half:])


def verify(code, alphabet=ID_CODE_ALPHABET, length=ID_CODE_LENGTH):
    """Return True when ``code`` has exactly ``length`` characters, all in the alphabet."""
    alphabet = _check_config(alphabet, length)
    clean = code.replace("-", "").upper()
    return len(clean) == length and all(c in alphabet for c in clean)


def decode(code, alphabet=ID_CODE_ALPHABET, length=ID_CODE_LENGTH):
    """Decode a code back to its integer id; raises ValueError when invalid."""
    if not verify(code, alphabet, length):
        raise ValueError("human-short-code: invalid code")
    clean = code.replace("-", "").upper()
    return sum(alphabet.upper().index(c) * len(alphabet) ** i for i, c in enumerate(clean))
