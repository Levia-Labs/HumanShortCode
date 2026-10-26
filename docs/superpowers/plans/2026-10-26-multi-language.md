# Multi-language support implementation plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** One spec, one shared vector file, and a tested one-file implementation in 12 languages, with the npm and PyPI packages rebuilt on the spec as 2.0.0.

**Architecture:** `spec/SPEC.md` defines behaviour; `spec/vectors.tsv` is the conformance suite every language test reads. Each `languages/<lang>/` folder is a native package layout holding one source file, one test, a minimal manifest and `test.sh`. `test.sh` runs the local toolchain when installed, else a pinned Docker image, through `languages/lib.sh`.

**Tech Stack:** Task, POSIX sh, Docker; pytest + hypothesis; jest + fast-check; go test; cargo test; JUnit-free `java` single-file tests; dotnet; Gradle Kotlin; SwiftPM; dart test; PHP CLI; Ruby minitest.

**Spec:** `docs/superpowers/specs/2026-10-26-multi-language-design.md`, `spec/SPEC.md`

## Global Constraints

1. Defaults: alphabet `ASDEIUNWRQXBOKH`, length `8`.
2. Codes for valid ids identical to 1.x: `encode(987654) == "QRQW-ISAA"`, `encode(0) == "AAAA-AAAA"`, `encode(2562890624) == "HHHH-HHHH"`.
3. Error messages start with `human-short-code:`.
4. Source file per language at most about 40 lines, no runtime dependencies.
5. Test reads `spec/vectors.tsv` relative to the repository root; no JSON.
6. Docker images pinned to an exact version tag.
7. Python and TypeScript packages version `2.0.0`.
8. No em dashes; LF line endings; each new folder gets a README (`docs/folder-purposes.toml` entry).

## Review Focus

1. Lower-case and hyphen-free input (`qrqwisaa`) decodes like `QRQW-ISAA`.
2. Codes with extra hyphens (`QR-QW-ISAA`) are accepted after normalization; wrong length is rejected.
3. `encode(N^length)` raises instead of wrapping to `AAAA-AAAA`.
4. Custom lower-case alphabet works because the alphabet is upper-cased too.
5. Length 1 produces a code with no hyphen.

Each line is a row in `spec/vectors.tsv`, so every language task covers it.

## Status: complete

1. Tasks 1 to 8 done; `task lang:test:all` green for all 12 languages.
2. Sources after the simplify pass: 44 to 68 lines (Go 68 keeps explicit error returns; Rust 59 after rustfmt).
3. Review fixes in cf55cdc: Java casing uses `Locale.ROOT`, JS/TS/Python reject non-integer lengths, Python/Ruby limit check stops after at most 53 multiplications.

---

### Task 1: Scaffold and move packages (main thread)

**Files:** move `python/` to `languages/python/`, `javascript/` to `languages/typescript/`; create `languages/lib.sh`, `tasks/languages.yml`; update `tasks/python.yml`, `tasks/javascript.yml`, `Taskfile.yml`, `docs/folder-purposes.toml`.

**Produces:** `run_tool <binary> <image> <command...>` in `languages/lib.sh`: runs `<command>` in the repo root when `<binary>` is on PATH, else in `docker run --rm -v <repo>:/w -w /w <image>`. `task lang:test -- <lang>` runs `sh languages/<lang>/test.sh`; `task lang:test:all` runs every `languages/*/test.sh`.

- [ ] `git mv` both packages; fix task paths; `task py:test` and `task js:test` still pass.
- [ ] Write `lib.sh` and `tasks/languages.yml`; commit.

### Task 2: Python reference and vectors

**Files:** `spec/vectors.tsv`, `languages/python/human_short_code/_core.py`, `languages/python/tests/test_vectors.py`, `languages/python/test.sh`, `languages/python/pyproject.toml` (2.0.0).

**Produces:** the vector file all later tasks consume; reference behaviour.

- [ ] Write `vectors.tsv` covering: the three Global Constraints anchors, max id, `N^length` error, negative error, custom alphabets (`0123456789` length 6, lower-case `abc` length 4), length 1, odd length 5, decode round trips, lower-case and hyphen-free decode, extra hyphens, wrong length, foreign character, alphabet of 1 char, duplicate-character alphabet, length 0, config over `Number.MAX_SAFE_INTEGER` (36 chars, length 13).
- [ ] Failing test: parametrize over every vector row.
- [ ] Rewrite `_core.py` to SPEC (validate config, range check, normalize, exact-length verify, decode raises `ValueError("human-short-code: ...")`, non-int raises `TypeError`); keep hypothesis round-trip test.
- [ ] `sh languages/python/test.sh` green; commit.

### Task 3: TypeScript package and JavaScript snippet

**Files:** `languages/typescript/src/index.ts`, its tests (vector-driven), `package.json` 2.0.0, `test.sh`; `languages/javascript/hsc.js`, `hsc.test.js`, `test.sh`.

- [ ] Vector-driven failing tests for both; implement to SPEC with `Number.isSafeInteger` checks; `hsc` namespace kept in TS; commit.

### Task 4: Go and Rust

**Files:** `languages/go/{go.mod,hsc.go,hsc_test.go,test.sh}` (module `github.com/Levia-Labs/HumanShortCode/languages/go`, `int64`, returns `error`); `languages/rust/{Cargo.toml,src/lib.rs,tests/vectors.rs,test.sh}` (`u64`/`i64`, `Result<_, String>`, image `rust:<pinned>`).

- [ ] Vector test first, implement, `test.sh` green, commit.

### Task 5: Java, Kotlin, C#

**Files:** `languages/java/{HumanShortCode.java,VectorsTest.java,test.sh}` (plain `java` source launcher, `long`, `IllegalArgumentException`); `languages/kotlin/{build.gradle.kts,settings.gradle.kts,src/main/kotlin/HumanShortCode.kt,src/test/kotlin/VectorsTest.kt,test.sh}` (image `gradle:<pinned>-jdk21`); `languages/csharp/{HumanShortCode.cs,HumanShortCode.csproj,tests/...,test.sh}` (`long`, `ArgumentException`).

- [ ] Vector test first, implement, `test.sh` green, commit.

### Task 6: PHP and Ruby

**Files:** `languages/php/{composer.json,src/HumanShortCode.php,tests/vectors.php,test.sh}` (`int`, `InvalidArgumentException`, image `php:<pinned>-cli`); `languages/ruby/{human_short_code.gemspec,lib/human_short_code.rb,test/test_vectors.rb,test.sh}` (`ArgumentError`, image `ruby:<pinned>`).

- [ ] Vector test first, implement, `test.sh` green, commit.

### Task 7: Swift and Dart

**Files:** `languages/swift/{Package.swift,Sources/HumanShortCode/HumanShortCode.swift,Tests/HumanShortCodeTests/VectorsTests.swift,test.sh}` (`Int64`, `throws`, image `swift:<pinned>`); `languages/dart/{pubspec.yaml,lib/human_short_code.dart,test/vectors_test.dart,test.sh}` (`int`, `ArgumentError`, image `dart:<pinned>`).

- [ ] Vector test first, implement, `test.sh` green, commit.

### Task 8: CI and docs

**Files:** `.github/workflows/languages.yml` (matrix over the 12 folders running `task lang:test -- <lang>`), root `README.md` language table, folder READMEs via `folder_readme.py update`, `CLAUDE.md` stack line.

- [ ] `task lang:test:all` green locally, `task quality:gate` green, commit.
