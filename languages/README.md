# Languages

Twelve implementations of the algorithm in [spec/SPEC.md](../spec/SPEC.md), each checked against the shared [spec/vectors.tsv](../spec/vectors.tsv).

| Language | Source file | Test command | Published |
| --- | --- | --- | --- |
| [Python](python/README.md) | `languages/python/human_short_code/_core.py` | `task lang:test -- python` | PyPI |
| [TypeScript](typescript/README.md) | `languages/typescript/src/index.ts` | `task lang:test -- typescript` | npm |
| [JavaScript](javascript/README.md) | `hsc.js` | `task lang:test -- javascript` | snippet |
| [Go](go/README.md) | `hsc.go` | `task lang:test -- go` | snippet |
| [Rust](rust/README.md) | `src/lib.rs` | `task lang:test -- rust` | snippet |
| [Java](java/README.md) | `HumanShortCode.java` | `task lang:test -- java` | snippet |
| [Kotlin](kotlin/README.md) | `src/main/kotlin/HumanShortCode.kt` | `task lang:test -- kotlin` | snippet |
| [C#](csharp/README.md) | `src/HumanShortCode/HumanShortCode.cs` | `task lang:test -- csharp` | snippet |
| [PHP](php/README.md) | `src/HumanShortCode.php` | `task lang:test -- php` | snippet |
| [Ruby](ruby/README.md) | `lib/human_short_code.rb` | `task lang:test -- ruby` | snippet |
| [Swift](swift/README.md) | `Sources/HumanShortCode/HumanShortCode.swift` | `task lang:test -- swift` | snippet |
| [Dart](dart/README.md) | `lib/human_short_code.dart` | `task lang:test -- dart` | snippet |

`task lang:test:all` runs every language. Tests run locally when the toolchain is installed, otherwise in Docker.
