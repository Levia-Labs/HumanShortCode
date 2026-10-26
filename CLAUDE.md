# HumanShortCode

Directives, agents and hooks come from the crepidoma plugin (github.com/Levia-Labs/Crepidoma).

## Project

1. Human-readable short code generator. One spec (`spec/SPEC.md`), one shared conformance suite (`spec/vectors.tsv`), one implementation per language under `languages/<lang>/`.
2. Published: `human-short-code` on PyPI (`languages/python/`) and npm (`languages/typescript/`). Other languages are copy-paste snippets in package-ready layouts.

## Stack

1. Python: hatchling, uv, pytest + hypothesis. TypeScript: tsc to `dist/`, jest + fast-check. Others: native test runner per language, no runtime dependencies.
2. Each `languages/<lang>/test.sh` uses the local toolchain when installed, else a pinned Docker image (`languages/lib.sh`); `HSC_FORCE_DOCKER=1` forces Docker, as CI does.

## Repo-specific rules

1. Behaviour changes start in `spec/SPEC.md` and `spec/vectors.tsv`; every language must pass the vectors before merge.
2. Keep each language source about 45 lines with no runtime dependencies.
3. The PyPI and npm packages share one version; release them together (`task py:publish`, `task ts:publish`, each gated on `CONFIRM=yes`).

## Commands

1. `task --list`; `task lang:test -- <lang>`, `task lang:test:all`; `claude:` and `lint:` come from the Crepidoma submodule.
