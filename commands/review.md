---
description: Review current changes for correctness and regressions
agent: review
---

Review the current working tree changes.

Context:
- `!`git status --short``
- `!`git diff --check``
- `!`git log --oneline -10``

Focus on $ARGUMENTS if provided, otherwise all uncommitted changes. Report severity, file/line, problem, why it matters, suggested correction.
