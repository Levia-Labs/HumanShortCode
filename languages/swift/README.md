# Swift

Human Short Code for Swift: encode integer ids as codes like `QRQW-ISAA`.

## Use

Copy `Sources/HumanShortCode/HumanShortCode.swift` into your project, or add the folder as a SwiftPM path dependency (the manifest lives in `languages/swift`, not the repo root).

```swift
.package(path: "languages/swift")
```

```swift
import HumanShortCode

let code = try HumanShortCode.encode(987654)  // "QRQW-ISAA"
let id = try HumanShortCode.decode(code)      // 987654
let ok = try HumanShortCode.verify(code)      // true
```

Errors: functions throw `HumanShortCodeError` for a bad config, an out-of-range id or an invalid code (`verify` returns `false`).

## Test

```bash
task lang:test -- swift
```
