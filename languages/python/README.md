<p align="center">
  <img src="https://raw.githubusercontent.com/Levia-Labs/HumanShortCode/master/docs/logo.svg" alt="HumanShortCode" width="120">
</p>

# human-short-code

Turn integer IDs into short, readable codes like `QRQW-ISAA`, and back.

## Install

```bash
pip install human-short-code
```

Requires Python 3.9 or newer.

## Usage

```python
from human_short_code import encode, decode, verify

code = encode(987654)
print(code)          # QRQW-ISAA
print(decode(code))  # 987654
print(verify(code))  # True
print(verify("ZZZZ-ZZZZ"))  # False
```

Command line:

```bash
python -m human_short_code 987654   # QRQW-ISAA
```

## API

All functions take an optional `alphabet` (default `"ASDEIUNWRQXBOKH"`) and `length` (default `8`, hyphen not counted). Also exported: `ID_CODE_ALPHABET`, `ID_CODE_LENGTH`.

- `encode(id_number: int, alphabet=..., length=...) -> str`: fixed-length code with a hyphen in the middle.
- `decode(code: str, alphabet=..., length=...) -> int`: input is case-insensitive. Raises `ValueError` for characters outside the alphabet.
- `verify(code: str, alphabet=..., length=...) -> bool`: `True` if the code has at most `length` characters, all in the alphabet.

## Custom alphabet

```python
alphabet = "ABCDEFGHJKLMNPQRSTUVWXYZ"

code = encode(987654, alphabet, 6)
print(code)                      # GSL-ZCA
print(decode(code, alphabet, 6)) # 987654
```

Use the same alphabet and length to decode as you did to encode.

## Range

With the defaults, valid IDs run from `0` to `15**8 - 1` (2,562,890,624). Larger IDs are silently truncated to the code length and will not round-trip: `encode(15**8)` returns `AAAA-AAAA`, the same as `encode(0)`. Negative numbers are not supported.

## Links

Source, JavaScript package and issues: https://github.com/Levia-Labs/HumanShortCode

MIT license.
