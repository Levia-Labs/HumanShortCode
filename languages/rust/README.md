# Rust

Human Short Code for Rust: encode integer ids as codes like `QRQW-ISAA`.

## Use

Copy `src/lib.rs` into your project, or depend on the folder (crate `human-short-code`).

```toml
human-short-code = { path = "languages/rust" }
```

```rust
use human_short_code::{decode, encode, verify, DEFAULT_ALPHABET, DEFAULT_LENGTH};

let code = encode(987654, DEFAULT_ALPHABET, DEFAULT_LENGTH).unwrap(); // "QRQW-ISAA"
let id = decode(&code, DEFAULT_ALPHABET, DEFAULT_LENGTH).unwrap();    // 987654
let ok = verify(&code, DEFAULT_ALPHABET, DEFAULT_LENGTH).unwrap();    // true
```

Errors: functions return `Err(String)` for a bad config, an out-of-range id or an invalid code (`verify` returns `Ok(false)` for an invalid code).

## Test

```bash
task lang:test -- rust
```
