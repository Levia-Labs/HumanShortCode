# Multi-language support design

Approved 2026-10-26.

## Goal

Copy-paste snippets for JavaScript, TypeScript, Python, Go, Rust, Java, C#, PHP, Ruby, Kotlin, Swift and Dart, each one file of at most about 40 lines, all checked against one shared test file. The npm and PyPI packages stay. Every language folder uses its native package layout, so publishing it later only adds registry metadata.

## Decisions

1. Behaviour is defined once in `spec/SPEC.md`; `spec/vectors.tsv` is the shared conformance suite. TSV, not JSON, so Java, Kotlin and Swift need no parser dependency.
2. Out-of-range, negative and non-integer ids raise. `decode` raises one consistent error for invalid codes. `verify` requires the exact length. Codes for valid ids do not change.
3. Ids are 64-bit integers; JavaScript and TypeScript cap configs at `Number.MAX_SAFE_INTEGER`.
4. `python/` moves to `languages/python/`, `javascript/` to `languages/typescript/`. Both packages become 2.0.0 (stricter validation is breaking).
5. `languages/javascript/hsc.js` is a dependency-free snippet; the npm package stays built from TypeScript.
6. `tasks/languages.yml`: `lang:test -- <lang>` uses the local toolchain when present, otherwise a pinned official Docker image; `lang:test:all` runs all. A GitHub Actions matrix runs the same task per language.
7. Work lands on branch `multi-language`, stacked on `crepidoma-migration` (PR #1).

## Rejected

1. Flat `snippets/` folder with one harness: smaller now, restructured again per language when packaged.
2. Code generation from a template: more machinery than the 10-line algorithm.
