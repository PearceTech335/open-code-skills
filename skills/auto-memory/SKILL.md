---
name: auto-memory
description: Session learning journal — read at session start to recall past solutions, write after task completion when a non-obvious insight was discovered. Provides cross-session continuity without RAG.
license: MIT
compatibility: opencode
metadata:
  audience: all-agents
  priority: base
---

## Purpose

Auto-memory persists non-obvious learnings across sessions. It stores:
- Debugging solutions that took time to discover
- Environment and infrastructure quirks specific to this machine
- Codebase conventions discovered during a session
- Failure patterns and what fixed them
- Ollama model behaviour quirks (tool call edge cases, context limits in practice)

This is NOT a general knowledge base. Only record things a future agent session
would genuinely benefit from knowing and would not find by reading code alone.

## Session Start — Read Memory

1. Read `~/.config/opencode/memory/MEMORY.md` (the index).
2. If the current task matches a topic in the index, read that topic file before proceeding.
3. If memory files do not exist yet, skip — nothing to read.

Example: task involves Python subprocess → check if `python.md` exists and read it.

## Session End — Write Memory

After completing a non-trivial task, evaluate:
1. Did I discover something non-obvious that would take >15 minutes to rediscover?
2. Did I solve a recurring error or an environment-specific issue?
3. Did I learn a convention specific to this machine, Ollama server, or project?

If YES to any — write a memory entry. If NO — skip. Do not write memory for things
the model already knows from training.

## Writing an Entry

Append to the relevant topic file at `~/.config/opencode/memory/<topic>.md`.
If the topic has no file yet, create it and add a line to MEMORY.md.

### Entry format:

```markdown
## <Short descriptive title> — <YYYY-MM-DD>

**Context**: What task triggered this. One sentence.
**Insight**: The non-obvious fact, fix, or pattern. Be specific.
**Evidence**: The command, output snippet, or code fragment that confirmed it.
```

### Example entry in `debugging.md`:

```markdown
## Ollama tool_call hangs on empty args object — 2026-07-02

**Context**: Trying to call a no-argument tool via qwen3:8b.
**Insight**: qwen3:8b requires at least one dummy field in args or it sends malformed JSON and hangs.
**Evidence**: Adding `"_": null` to the args schema resolved the hang immediately.
```

## MEMORY.md Index Format

Keep MEMORY.md under 200 lines. Move detailed entries to topic files when the index grows.

```markdown
# OpenCode Memory Index

Last updated: YYYY-MM-DD

## Topics

- **debugging.md** — Tool call hang fix (qwen3:8b empty args), ...
- **environment.md** — Ollama server 192.168.0.66: model load times, VRAM limits, ...
- **python.md** — subprocess timeout on Windows, pathlib vs os.path edge cases, ...
- **ansible.md** — vault decrypt on Windows path, molecule driver quirks, ...
```

## Memory File Hygiene

- Keep each topic file under 150 lines. Archive old entries to `<topic>-archive.md` if needed.
- Correct or delete entries that turn out to be wrong.
- Do not duplicate knowledge the model already has from training.
- Do not record a pattern as a general best practice simply because it solved one problem. Record the environment, version, assumptions, and evidence — and revisit entries when they become stale.
- Use the entry date to prune stale environment-specific entries (>6 months).

## Directory Layout

```
~/.config/opencode/memory/
├── MEMORY.md           # Index — summary of all topics, keep under 200 lines
├── debugging.md        # Error patterns, surprising fixes
├── environment.md      # Machine/Ollama server quirks
├── python.md           # Python-specific non-obvious patterns
├── ansible.md          # Ansible-specific insights
├── powershell.md       # PowerShell on Windows quirks
└── go.md               # Go toolchain and module insights
```
