# Dart

Human Short Code for Dart: encode integer ids as codes like `QRQW-ISAA`.

## Use

Copy `lib/human_short_code.dart` into your project, or add the folder as a path dependency (package `human_short_code`).

```yaml
dependencies:
  human_short_code:
    path: languages/dart
```

```dart
import 'package:human_short_code/human_short_code.dart';

final code = encode(987654);  // "QRQW-ISAA"
final id = decode(code);      // 987654
final ok = verify(code);      // true
```

`alphabet` and `length` are optional named arguments.

Errors: `ArgumentError` for a bad config, an out-of-range id or an invalid code (`verify` returns `false`).

## Test

```bash
task lang:test -- dart
```
