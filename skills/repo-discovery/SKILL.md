---
name: repo-discovery
description: Repository exploration and architecture understanding. Use BEFORE changing an unread subsystem, regardless of language skill. Explicit tool sequence with citation and completion rules so small models cannot fabricate paths.
license: MIT
compatibility: all
metadata:
  priority: high
---

## When to Run

Run before modifying code you have not read in this session. Skip only for
trivial single-line fixes in files you have already read. Do not read and
summarise the entire repository when only a small, well-understood area needs
modification.

## Hard Rules (small-model safety)

1. **Every path and line number you report must be copied from a tool result
   in this session.** If no `glob`, `grep`, or `read` produced it, you may not
   state it. If you did not check, say `UNKNOWN`.
2. **Read in slices of ≤150 lines** with `offset`/`limit` (the tool-output cap
   is 200 lines). If a result is truncated or ends mid-construct, re-read from
   the last received line before drawing conclusions.
3. **Grep with a limit** (for example `-m 50` or a bounded file glob). Narrow
   the pattern instead of dumping matches.
4. **Label evidence** `VERIFIED` (tool output), `INFERRED` (one source or
   indirect), `UNKNOWN` (not established). Never present a guessed path as
   verified.
5. **No completion without the report in Step 6.** Discovery is finished when
   you can list what you inspected and what remains unknown.

## Step 1 — Find Entry Points

1. Glob for common entry files: `**/{main,index,app,cmd,server,bootstrap}.*`.
2. Read the top-level directory listing.
3. Open the 1–3 most likely entry files (≤150 lines each) and record their
   paths verbatim.
4. Identify the CLI/API surface: routes, commands, exported functions.

## Step 2 — Map Dependencies

1. Read the dependency manifest (`package.json`, `go.mod`, `pyproject.toml`,
   `requirements.txt`, `Cargo.toml`).
2. Note third-party packages already in use — do not propose alternatives
   without a reason.
3. Identify internal boundaries (`internal/`, `pkg/`, `src/`, `lib/`).

## Step 3 — Trace the Relevant Path

For the specific change requested:

1. Start from the nearest public entry point.
2. Grep the symbol/route name; follow imports and calls into the change area.
3. Record every file that reads or writes the affected data or state, with
   `file:line` from the grep/read output.
4. Note error-handling conventions (return codes, exceptions, result types).

## Step 4 — Identify Existing Patterns

Before writing new code, find two or three examples of the pattern:

- Grep for similar functions, handlers, or components.
- Note naming conventions for files, functions, variables, tests.
- Note code style, comment density, logging, and test layout.

Reuse patterns already present. A second style creates maintenance debt.

## Step 5 — State Constraints

State explicitly, in the task detail file:

- What will change.
- What will NOT change.
- Framework conventions the change must respect.
- Whether backward compatibility must be preserved.

Hand the plan to `agent-core`'s Plan phase; do not restate the whole plan here.

## Git State (conditional)

- If `bash` is available: run `git status`, inspect the diff, and run
  `git diff --check`. Never overwrite unrelated uncommitted changes.
- If `bash` is denied (for example the `research` subagent): report
  `git state UNAVAILABLE (bash denied)` and label every working-tree
  conclusion `UNKNOWN`. Do not invent a clean/dirty result.

## Completion Report (required)

Before handing off, report:

- Directories inspected.
- Files read (paths; note any slice that was truncated).
- Entry points identified.
- Dependency manifests inspected.
- Tests discovered and the command that runs them.
- Unresolved questions / `UNKNOWN` items.
- The evidence label for each relationship you claim.

## When Structure Is Unclear

If the architecture is still ambiguous after exploration, stop and surface the
ambiguity. Do not guess at conventions and apply them across many files.
