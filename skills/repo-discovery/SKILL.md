---
name: repo-discovery
description: Repository exploration and architecture understanding. Use BEFORE making any changes to an unfamiliar codebase or unfamiliar area of a known codebase.
license: MIT
compatibility: all
metadata:
  priority: high
---

## When to Run This Skill

Run this before modifying code you have not read in this session. Skip only for trivial single-line fixes in files you have already explored. Do not read and summarise the entire repository when only a small, well-understood area needs modification.

## Step 1 — Find Entry Points

Locate the bootstrapping and main execution paths:

- Look for `main`, `index`, `app`, `cmd`, `bootstrap`, `server` files at the top level.
- Check `package.json` scripts, `Makefile` targets, `pyproject.toml` entry points, or `go.mod` module name.
- Identify the CLI/API surface: routes, commands, or exported functions that external callers use.

## Step 2 — Map Dependencies

Understand what the codebase depends on:

- Read the dependency manifest (`package.json`, `go.mod`, `pyproject.toml`, `requirements.txt`, `Cargo.toml`).
- Note which third-party packages are already in use — do not propose alternatives without a reason.
- Identify internal package/module boundaries (`internal/`, `pkg/`, `src/`, `lib/`).

## Step 3 — Trace the Relevant Path

For the specific change requested, trace the call chain:

1. Start from the nearest public entry point.
2. Follow imports and function calls into the area of change.
3. Identify every file that reads or writes the data or state being modified.
4. Note error handling conventions already in use (return codes vs. exceptions vs. result types).

## Step 4 — Identify Existing Patterns

Before writing any new code, find two or three examples of the pattern you are about to implement:

- Search for similar functions, handlers, or components already in the repo.
- Note naming conventions: file names, function names, variable names, test file names.
- Note code style: indentation, comment density, logging approach.
- Note test patterns: fixture layout, mock strategy, assertion style.

**Reuse patterns already present.** Introducing a second style creates maintenance debt.

## Step 5 — State Constraints

Before writing the plan, explicitly state:

- What will change.
- What will NOT change.
- Any framework conventions the change must respect (e.g., ORM patterns, router registration, DI container).
- Whether backward compatibility must be preserved.

## Git State

Before modifying:

- `git status` — list clean vs dirty files.
- Inspect existing diff; identify uncommitted user changes.
- Never overwrite unrelated changes.

After modifying:

- `git diff` — review own changes.
- `git diff --check` — no whitespace errors.

## Reuse Over Reinvention

- Prefer existing utilities over new implementations.
- Do not duplicate logic already present in the repo.
- If a helper already does 80% of the job, extend it rather than write a parallel version.

## When Structure Is Unclear

If the architecture is ambiguous after exploration, stop and surface the ambiguity. Do not guess at conventions and then apply them incorrectly across many files.
