# Human Short Code specification

Every implementation in `languages/` follows this file and passes `vectors.tsv`.

## API

| Function | Returns | Raises |
| --- | --- | --- |
| `encode(id, alphabet = "ASDEIUNWRQXBOKH", length = 8)` | code string, for example `QRQW-ISAA` | invalid config; `id` negative, not an integer, or `>= N^length` |
| `decode(code, alphabet = "ASDEIUNWRQXBOKH", length = 8)` | integer id | invalid config; `verify(code)` is false |
| `verify(code, alphabet = "ASDEIUNWRQXBOKH", length = 8)` | boolean | invalid config |

Use the language's naming convention (`Encode` in Go and C#, `HumanShortCode.encode` in Java) and its usual error type. Error messages start with `human-short-code:`.

## Rules

1. **Config.** `alphabet` should be printable ASCII without `-`; other characters behave differently across languages (PHP compares bytes, Python code points). It is upper-cased and must hold at least 2 characters, all unique. `length` must be at least 1. `N^length - 1`, with `N` the alphabet size, must not exceed `2^53 - 1` (JavaScript's `Number.MAX_SAFE_INTEGER`) in every language, so one config and one vector file behave the same everywhere. Use 64-bit integers where the language has fixed-width types.
2. **Encode.** Write `id` in base `N`, least significant digit first, mapping digit `d` to `alphabet[d]`. Pad on the right with `alphabet[0]` to `length` characters. Insert `-` after the first `floor(length / 2)` characters; when that is 0 (length 1), insert nothing.
3. **Normalize.** Remove every `-` and upper-case the rest.
4. **Verify.** The normalized code has exactly `length` characters, all in the alphabet.
5. **Decode.** Sum `index(alphabet, c) * N^i` over the normalized code, `i` starting at 0.

`decode(encode(id)) == id` for every `0 <= id < N^length`. Codes for valid ids are identical to versions 1.x.

## Test vectors

`vectors.tsv` is tab-separated, one case per line, `#` starts a comment line.

| Column | Meaning |
| --- | --- |
| `op` | `encode`, `decode` or `verify` |
| `input` | id (decimal) for `encode`, code for `decode` and `verify` |
| `alphabet` | alphabet, or `-` for the default |
| `length` | length, or `-` for the default |
| `expected` | code, id, `true`, `false`, or `!error` when the call must raise |

Rows also pin the config limit: `01` with length 53 is valid, length 54 raises; `0123456789` with length 15 is valid, length 16 raises.
