---
name: template-library
description: Tool and script template library — search, retrieve, and save reusable code patterns. Use BEFORE writing any new tool, script, or utility to check if the pattern already exists.
license: MIT
compatibility: opencode
metadata:
  audience: all-agents
  priority: normal
---

## When to Load This Skill

Load when the task involves a recurring or non-trivial pattern, an existing template is likely to apply, or the task explicitly calls for reuse. For simple one-off scripts, follow established project conventions first — searching the library for every small utility costs more time than it saves.

Also load when:
- Writing a new tool, helper function, CLI wrapper, or automation that could recur.
- Solving a problem type that is likely to recur (file processing, HTTP retry, API auth, config parsing).
- Completing a task that produced a reusable, general-purpose pattern.

## Step 1 — Search Before Building

Before writing any new tool, search the template library:

```bash
# Search by keyword in descriptions
grep -r "<keyword>" ~/.config/opencode/templates/ --include="*.md" -l

# Search by tag
grep -r "tags:.*<tag>" ~/.config/opencode/templates/ --include="*.md" -l

# List all templates for a language
ls ~/.config/opencode/templates/<language>/
```

Examples:
- Retry pattern: `grep -r "retry" ~/.config/opencode/templates/ --include="*.md" -l`
- Python HTTP: `grep -r "tags:.*http" ~/.config/opencode/templates/python/ -l`
- Ansible vault: `grep -r "vault" ~/.config/opencode/templates/ansible/ -l`

If a matching template exists, read it and adapt it — do not rewrite from scratch.

## Step 2 — Adapt, Not Copy

When using a template:
- Read the full template including the Notes section.
- Adapt parameter names, types, and defaults to the current project's conventions.
- Do not paste templates verbatim if the project style differs.

## Step 3 — Save Successful Patterns

After completing a task, ask: *"Would a future agent spend >10 minutes figuring this out again?"*

If YES — save it.

**Save when:**
- The pattern solves a general, reusable problem (retry logic, stream processing, auth headers, file walking).
- You discovered a non-obvious API flag, module behaviour, or platform quirk.
- The code is >15 lines and the pattern is language/framework-general.

**Do NOT save:**
- Project-specific business logic.
- One-off fixes tied to a specific codebase.
- Patterns the model already knows from training (basic loops, standard CRUD).

## Template File Format

Save to: `~/.config/opencode/templates/<language>/<descriptive-name>.md`

```markdown
---
name: http-retry-backoff
language: python
tags: [python, http, retry, backoff, requests]
use-case: Retry an HTTP GET/POST with exponential backoff and jitter
created: YYYY-MM-DD
---

## Description

One-paragraph description of what this pattern does and when to use it.

## Usage

How to call it. Parameter meanings. Return value.

## Code

\```python
# complete, runnable code here
\```

## Notes

- Edge cases, gotchas, or adaptation hints.
- Known limitations.
```

## Directory Layout

```
~/.config/opencode/templates/
├── python/
│   ├── http-retry-backoff.md
│   └── csv-stream-processor.md
├── bash/
│   └── parallel-find-process.md
├── powershell/
│   └── remote-retry-invoke.md
├── go/
│   └── graceful-shutdown-http-server.md
└── ansible/
    └── idempotent-package-install.md
```

## Sample Template Pointer

See `templates/python/http-retry-backoff.md` for a full example (retry with backoff + jitter). Read the actual template file only when needed — do not inline it here.
