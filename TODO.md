# TODO

## 1 Narrow .claude/settings.json allowlist and pin plugin marketplace ref

status: open
class: security

Copied from Crepidoma templates/settings.json. Bash(task *) and Bash(pre-commit run *) allow -t/--taskfile/-c escapes; Bash(git commit *) lacks --no-verify/-n deny; git diff/log/show allow --output/--ext-diff; marketplace ref is main, not a SHA. Fix upstream in Crepidoma template, then resync this pillar.
