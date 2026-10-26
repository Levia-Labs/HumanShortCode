# Kotlin

Human Short Code for Kotlin: encode integer ids as codes like `QRQW-ISAA`.

## Use

Copy `src/main/kotlin/HumanShortCode.kt` into your project.

```kotlin
val code = HumanShortCode.encode(987654L)  // "QRQW-ISAA"
val id = HumanShortCode.decode(code)       // 987654
val ok = HumanShortCode.verify(code)       // true
```

`alphabet` and `length` are optional named arguments.

Errors: `IllegalArgumentException` for a bad config, an out-of-range id or an invalid code (`verify` returns `false`).

## Test

```bash
task lang:test -- kotlin
```
