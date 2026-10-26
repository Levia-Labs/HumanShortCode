<div align="center">

<img src="docs/logo.svg" alt="Human Short Code logo: a long id folding into an ABCD-EFGH code" width="120">

# Human Short Code

**Turn long numeric ids into short codes people can read, say and type.**

`987654` becomes `QRQW-ISAA`, and decodes back to `987654`.

[![PyPI](https://img.shields.io/pypi/v/human-short-code.svg)](https://pypi.org/project/human-short-code/)
[![npm](https://img.shields.io/npm/v/human-short-code.svg)](https://www.npmjs.com/package/human-short-code)
[![license: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![built on Crepidoma](https://img.shields.io/badge/built%20on-Crepidoma-d97757.svg)](https://github.com/Levia-Labs/Crepidoma)

</div>

## Why

1. **Readable.** Fixed-length `ABCD-EFGH` codes with a hyphen in the middle, easy to dictate over the phone.
2. **Reversible.** Encoding is a bijection on the id range; no lookup table or database needed.
3. **Configurable.** Bring your own alphabet and code length.
4. **Zero dependencies.** Same algorithm and output in 12 languages, defined by [spec/SPEC.md](spec/SPEC.md).

Good fits: referral codes, room codes, order and ticket references, support ids.

## Quick start

Python:

```bash
pip install human-short-code
```

```python
from human_short_code import encode, decode, verify

code = encode(987654)   # "QRQW-ISAA"
decode(code)            # 987654
verify(code)            # True
```

JavaScript / TypeScript:

```bash
npm install human-short-code
```

```ts
import { hsc } from "human-short-code";

const code = hsc.encode(987654); // "QRQW-ISAA"
hsc.decode(code);                // 987654
hsc.verify(code);                // true
```

The default alphabet `ASDEIUNWRQXBOKH` with length 8 covers ids from 0 to 15^8 - 1 (2,562,890,624).

## Languages

| Language | Install or copy |
| --- | --- |
| [Python](languages/python/README.md) | `pip install human-short-code` |
| [TypeScript](languages/typescript/README.md) | `npm install human-short-code` |
| [JavaScript](languages/javascript/README.md) | copy `hsc.js` |
| [Go](languages/go/README.md) | `go get github.com/Levia-Labs/HumanShortCode/languages/go` |
| [Rust](languages/rust/README.md) | copy `src/lib.rs` or path dependency |
| [Java](languages/java/README.md) | copy `HumanShortCode.java` |
| [Kotlin](languages/kotlin/README.md) | copy `HumanShortCode.kt` |
| [C#](languages/csharp/README.md) | copy `HumanShortCode.cs` or project reference |
| [PHP](languages/php/README.md) | copy `HumanShortCode.php` or path repository |
| [Ruby](languages/ruby/README.md) | copy `human_short_code.rb` or path gem |
| [Swift](languages/swift/README.md) | copy `HumanShortCode.swift` or path dependency |
| [Dart](languages/dart/README.md) | copy `human_short_code.dart` or path dependency |

See [languages/README.md](languages/README.md) for source paths and test commands.

## Development

Tasks run through [Task](https://taskfile.dev); `task --list` is the index.

```bash
git clone --recurse-submodules https://github.com/Levia-Labs/HumanShortCode.git
task lang:test:all   # every language against spec/vectors.tsv
task py:test         # Python package only
task ts:test         # TypeScript package only
```

## Levia Labs

1. [Crepidoma](https://github.com/Levia-Labs/Crepidoma): the shared LLM tooling foundation this repo is built on.
2. [QC2C](https://github.com/Levia-Labs/QC2C): quick coordinates to country.
3. [beat-analyser](https://github.com/Levia-Labs/beat-analyser): music beat data extraction with madmom, dockerized.
4. [saber-tooth](https://github.com/Levia-Labs/saber-tooth): Beat Saber modding API for custom levels.

## License

[MIT](LICENSE)
