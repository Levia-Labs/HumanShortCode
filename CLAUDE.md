# HumanShortCode

Directives, agents and hooks come from the crepidoma plugin (github.com/Levia-Labs/Crepidoma).

## Project

1. Human-readable short code generator, published as `human-short-code` for Python (`python/`) and TypeScript (`javascript/`).

## Stack

1. Python package (hatchling, uv, pytest + hypothesis, `python/`); TypeScript package (tsc to `dist/`, jest + fast-check, `javascript/`).
2. Both packages share one algorithm and version; change and release them together (`task py:publish`, `task js:publish`, each gated on `CONFIRM=yes`).

## Repo-specific rules

1. Rules only for this repo; shared rules belong in Crepidoma.

## Commands

1. `task --list`; `claude:` and `lint:` come from the Crepidoma submodule.
