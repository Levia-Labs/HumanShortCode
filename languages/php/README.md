# PHP

Human Short Code for PHP 8.1+: encode integer ids as codes like `QRQW-ISAA`.

## Use

Copy `src/HumanShortCode.php` into your project, or add the folder as a Composer path repository (package `levia-labs/human-short-code`).

```php
use LeviaLabs\HumanShortCode\HumanShortCode;

$code = HumanShortCode::encode(987654);  // "QRQW-ISAA"
$id = HumanShortCode::decode($code);     // 987654
$ok = HumanShortCode::verify($code);     // true
```

`$alphabet` and `$length` are optional parameters.

Errors: `InvalidArgumentException` for a bad config, an out-of-range id or an invalid code (`verify` returns `false`).

## Test

```bash
task lang:test -- php
```
