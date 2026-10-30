---
name: bash-skill
description: Bash skill for safe shell automation and predictable script behavior
license: MIT
compatibility: opencode
metadata:
  language: bash
---

# Bash Coding Standards

Strong defaults, not rigid rules. Use engineering judgement where context warrants it.

## Strong Defaults

1. **Start with `#!/usr/bin/env bash` and `set -euo pipefail`.** Understand the script's control flow — these flags have edge cases and do not guarantee safe execution on their own.

2. **Quote variable expansions.** `"$var"`, `"$@"`, `"$(cmd)"`. Unquoted expansions are bugs.

3. **Use arrays for lists, not space-joined strings.** Iterate with `"${arr[@]}"`. Use `IFS= read -r` for line input.

4. **Never parse `ls` output.** Use globs or `find -print0`.

5. **Use `[[ ]]` for tests, not `[ ]`.** Safer, supports regex and glob matching.

6. **Use `mktemp` for temp files and `trap cleanup EXIT` for cleanup.** Never write to predictable paths.

7. **Check `command -v` before invoking optional tools.** Fail with a clear message if missing.

8. **Never use `eval`.** Use arrays or explicit `case` dispatch.

9. **Loops need termination strategies.** Bounded loops, explicit exits, or signal handling — whichever fits. Use `timeout` for commands that can hang, not for every command.

10. **Run `bash -n` and `shellcheck` before reporting done.** Report what was actually verified.

## Verification Order

1. Syntax: `bash -n script.sh`
2. Lint: `shellcheck script.sh`
3. Dry-run: `-n` or `--dry-run` flag if supported
4. Trace: `bash -x script.sh` on first smoke test
