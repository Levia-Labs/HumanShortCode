"""
HumanShortCode: Encode and decode integer IDs into short, human-readable strings.

Uses a fixed-length format with a custom non-ambiguous alphabet and a middle hyphen
to increase legibility. Provides deterministic reversible transformation between integers
and readable codes.
"""

ID_CODE_ALPHABET = "ASDEIUNWRQXBOKH"
ID_CODE_LENGTH = 8


def encode(id_number, alphabet=ID_CODE_ALPHABET, length=ID_CODE_LENGTH):
    """
    Encode an integer ID into a fixed-length human-readable string.

    Args:
        id_number (int): The integer to encode.
        alphabet (str): A string of unique characters used as the encoding base.
        length (int): The total length of the resulting code (including padding).

    Returns:
        str: Encoded string with a hyphen inserted at the midpoint.

    Example:
        encode(123456) -> 'DNRX-BKAA'
    """
    code_base = len(alphabet)
    indices = []

    while id_number > 0:
        indices.append(id_number % code_base)
        id_number //= code_base

    indices += [0] * (length - len(indices))
    letters = "".join(alphabet[i] for i in indices[:length])
    half = length // 2
    return letters[:half] + "-" + letters[half:]


def decode(id_string, alphabet=ID_CODE_ALPHABET, length=ID_CODE_LENGTH):
    """
    Decode a previously encoded string back into its original integer.

    Args:
        id_string (str): The encoded string, possibly containing a hyphen.
        alphabet (str): The alphabet used for encoding.
        length (int): Expected length of the decoded string.

    Returns:
        int: The original integer before encoding.

    Example:
        decode('DNRX-BKAA') -> 123456
    """
    code_base = len(alphabet)
    id_string = id_string.replace("-", "").upper().ljust(length, alphabet[0])
    return sum(alphabet.index(c) * (code_base**i) for i, c in enumerate(id_string))
