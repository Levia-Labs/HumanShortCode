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

1. **Config.** `alphabet` is upper-cased and must hold at least 2 characters, all unique. `length` must be at least 1. `N^length - 1`, with `N` the alphabet size, must fit in a signed 64-bit integer (JavaScript and TypeScript: `Number.MAX_SAFE_INTEGER`).
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

Vector ids and every config stay within `Number.MAX_SAFE_INTEGER`, so all languages share one file.
