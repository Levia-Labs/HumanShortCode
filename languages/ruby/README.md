# Ruby

Human Short Code for Ruby: encode integer ids as codes like `QRQW-ISAA`.

## Use

Copy `lib/human_short_code.rb` into your project, or point Bundler at the folder (gem `human_short_code`).

```ruby
gem 'human_short_code', path: 'languages/ruby'
```

```ruby
require 'human_short_code'

code = HumanShortCode.encode(987654)  # "QRQW-ISAA"
id = HumanShortCode.decode(code)      # 987654
ok = HumanShortCode.verify(code)      # true
```

`alphabet:` and `length:` are optional keywords.

Errors: `ArgumentError` for a bad config, an out-of-range id or an invalid code (`verify` returns `false`).

## Test

```bash
task lang:test -- ruby
```
