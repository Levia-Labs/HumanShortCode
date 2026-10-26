# C#

Human Short Code for C#: encode integer ids as codes like `QRQW-ISAA`.

## Use

Copy `src/HumanShortCode/HumanShortCode.cs` into your project, or reference the project (.NET 8).

```bash
dotnet add reference languages/csharp/src/HumanShortCode/HumanShortCode.csproj
```

```csharp
string code = HumanShortCode.Encode(987654);  // "QRQW-ISAA"
long id = HumanShortCode.Decode(code);        // 987654
bool ok = HumanShortCode.Verify(code);        // true
```

`alphabet` and `length` are optional parameters.

Errors: `ArgumentException` for a bad config, an out-of-range id or an invalid code (`Verify` returns `false`).

## Test

```bash
task lang:test -- csharp
```
