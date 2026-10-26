# JavaScript

Human Short Code as one dependency-free file for Node and browsers: encode integer ids as codes like `QRQW-ISAA`.

## Use

Copy `hsc.js` into your project or paste it into a browser console. For npm, use the [TypeScript package](../typescript/README.md).

```js
const { encode, decode, verify } = require("./hsc.js");

const code = encode(987654);  // "QRQW-ISAA"
const id = decode(code);      // 987654
const ok = verify(code);      // true
```

`alphabet` and `length` are optional arguments.

Errors: `TypeError` for a non-integer id, `RangeError` for a bad config or out-of-range id, `Error` for an invalid code (`verify` returns `false`).

## Test

```bash
task lang:test -- javascript
```
