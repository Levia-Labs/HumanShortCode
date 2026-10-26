# Java

Human Short Code for Java: encode integer ids as codes like `QRQW-ISAA`.

## Use

Copy `HumanShortCode.java` (no package, no dependencies) into your project.

```java
String code = HumanShortCode.encode(987654);  // "QRQW-ISAA"
long id = HumanShortCode.decode(code);        // 987654
boolean ok = HumanShortCode.verify(code);     // true
```

Overloads taking `(alphabet, length)` set a custom config.

Errors: `IllegalArgumentException` for a bad config, an out-of-range id or an invalid code (`verify` returns `false`).

## Test

```bash
task lang:test -- java
```
