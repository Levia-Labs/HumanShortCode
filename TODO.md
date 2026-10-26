# TODO

## 1 Narrow .claude/settings.json allowlist and pin plugin marketplace ref

status: open
class: security

Copied from Crepidoma templates/settings.json. Bash(task *) and Bash(pre-commit run *) allow -t/--taskfile/-c escapes; Bash(git commit *) lacks --no-verify/-n deny; git diff/log/show allow --output/--ext-diff; marketplace ref is main, not a SHA. Fix upstream in Crepidoma template, then resync this pillar.

## 2 Align Python and JS decode/verify validation; reject ids above range

status: done
class: bug

Python decode raises bare ValueError ('substring not found') without calling verify, JS throws 'invalid idString'. Hyphen stripping differs between verify and decode. encode(15**8) silently truncates to AAAA-AAAA, colliding with encode(0); both packages should raise on out-of-range ids. Start with failing tests in python/tests and javascript/tests.

## 3 Isolate Docker test artifacts from host runs

status: done
class: bug

languages/typescript/test.sh and languages/python/test.sh write node_modules and .venv into the mounted tree when run in Docker; a later host run reuses Linux-built binaries or venv and fails. Use a container-only volume or temp dir for node_modules and UV_PROJECT_ENVIRONMENT in the Docker branch of languages/lib.sh.
