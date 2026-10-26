<p align="center">
  <img src="https://raw.githubusercontent.com/Levia-Labs/HumanShortCode/master/docs/logo.svg" alt="HumanShortCode" width="120">
</p>

# human-short-code

Turn integer IDs into short, readable codes like `QRQW-ISAA`, and back.

## Install

```bash
npm install human-short-code
```

Requires Node 18 or newer. TypeScript types are included.

## Usage

```typescript
import { hsc } from "human-short-code";

const code = hsc.encode(987654);
console.log(code);                  // "QRQW-ISAA"
console.log(hsc.decode(code));      // 987654
console.log(hsc.verify(code));      // true
console.log(hsc.verify("ZZZZ-ZZZZ")); // false
```

`encode`, `decode`, `verify`, `ID_CODE_ALPHABET` and `ID_CODE_LENGTH` are also available as named exports.

## API

All functions take an optional `alphabet` (default `"ASDEIUNWRQXBOKH"`) and `length` (default `8`, hyphen not counted).

- `encode(idNumber: number, alphabet?: string, length?: number): string`: fixed-length code with a hyphen in the middle.
- `decode(idString: string, alphabet?: string, length?: number): number`: input is case-insensitive and hyphens are ignored. Throws `human-short-code: invalid code` if `verify` fails.
- `verify(code: string, alphabet?: string, length?: number): boolean`: `true` if the code, ignoring hyphens and case, has exactly `length` characters, all in the alphabet.

## Custom alphabet

```typescript
import { encode, decode } from "human-short-code";

const alphabet = "ABCDEFGHJKLMNPQRSTUVWXYZ";

const code = encode(987654, alphabet, 6);
console.log(code);                       // "GSL-ZCA"
console.log(decode(code, alphabet, 6));  // 987654
```

Use the same alphabet and length to decode as you did to encode.

## Range

With the defaults, valid IDs run from `0` to `15**8 - 1` (2,562,890,624). `encode` throws `RangeError` for negative IDs and IDs of `15 ** 8` or more, and `TypeError` for non-integers. An alphabet and length whose `N ** length - 1` exceeds `Number.MAX_SAFE_INTEGER` throws `RangeError`.

## Links

Source, Python package and issues: https://github.com/Levia-Labs/HumanShortCode

MIT license.
