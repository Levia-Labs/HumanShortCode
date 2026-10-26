# Go

Human Short Code for Go: encode integer ids as codes like `QRQW-ISAA`.

## Use

Add the module, or copy `hsc.go` (package `hsc`) into your project.

```bash
go get github.com/Levia-Labs/HumanShortCode/languages/go
```

```go
import hsc "github.com/Levia-Labs/HumanShortCode/languages/go"

code, _ := hsc.Encode(987654, hsc.DefaultAlphabet, hsc.DefaultLength) // "QRQW-ISAA"
id, _ := hsc.Decode(code, hsc.DefaultAlphabet, hsc.DefaultLength)     // 987654
ok, _ := hsc.Verify(code, hsc.DefaultAlphabet, hsc.DefaultLength)     // true
```

Errors: every function returns an `error` for a bad config, an out-of-range id or an invalid code (`Verify` reports an invalid code as `false`).

## Test

```bash
task lang:test -- go
```
