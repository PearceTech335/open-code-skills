---
name: python-code
description: Python production coding — correctness, safety, and maintainability defaults
license: MIT
compatibility: opencode
metadata:
  language: python
---

# Python Coding Standards

Strong defaults, not rigid rules. Use engineering judgement where context warrants it.

## Strong Defaults

1. **Type hints on public function signatures** — parameters and return type. Internal helpers can omit obvious ones.

2. **Use `pathlib.Path` for file operations.** Prefer it over `os.path` string concatenation.

3. **Handle errors where you can recover, add context, or translate them.** Do not wrap every I/O call in try/except if the error can propagate to a handler that does something useful with it. Never use bare `except:` — catch specific types.

4. **Never silently swallow an error.** Log with context, re-raise with `raise NewError(f"context: {exc}") from exc`, or return a documented sentinel.

5. **Use `with` for files, sockets, and database connections.** Deterministic cleanup.

6. **Prefer stdlib when it is clear and appropriate.** `pathlib`, `dataclasses`, `argparse`, `logging`, `json`, `sqlite3` first. Third-party is fine when justified — just do not add dependencies casually.

7. **Validate external input at trust boundaries.** Define what is valid; reject invalid input with a clear error.

8. **Use `dataclasses` or `NamedTuple` when the data has a stable structure** and the extra definition improves clarity. Dictionaries are fine for dynamic config, JSON payloads, and loosely structured data.

9. **Keep functions cohesive.** One clear responsibility with manageable control flow. A 60-line linear procedure is fine if it reads clearly; split when a reader would struggle.

10. **Run `python -m py_compile` and `pytest` before reporting done.** Report what was actually verified.

## Verification Order

1. Syntax: `python -m py_compile changed_file.py`
2. Lint: `ruff check` on changed files
3. Typecheck: `mypy` if configured
4. Test: `pytest <target>` then full `pytest`
