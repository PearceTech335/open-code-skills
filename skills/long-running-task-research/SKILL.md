---
name: long-running-task-research
description: Autonomous long-running task research — persistent notes, source-linked evidence, resumable state, design review, and overnight-safe verification.
license: MIT
compatibility: opencode
metadata:
  audience: overnight-agent
  priority: high
---

# Long-Running Task Research

Use this skill for autonomous, unattended, multi-stage, or long-running tasks that may span context compaction, session restarts, or overnight runs. Examples: repository audits, benchmarks, migrations, multi-file refactors, security reviews, performance investigations.

## Load Before Starting

Read these skills before any long-running task:
- `agent-core` — base rules, four-phase protocol, verification.
- `repo-discovery` — find entry points, trace paths, identify patterns, state constraints.
- `readable-code` — maintainability, naming, simplicity, documentation.
- `designer` — design principles (single responsibility, separation of concerns, dependency direction, minimal abstraction, domain terminology, testability).
- `research-method` — self-critique, cross-check, references, webfetch policy.
- `quality-gate` — final verification checklist (hard requirements + maintainability + correctness + scope).

## 1. Working State Before Editing

Before changing anything:

Identify repository root. Inspect Git status. Preserve user changes. Read `AGENTS.md`, `TASKS.md`, `PROGRESS.md`, `README.md`, and any `memory/*.md` files. Understand the task objective, acceptance criteria, constraints, risk boundaries, and expected duration.

Identify protected paths: production/live endpoints, deployment configs, security boundaries, user data. Do not modify these unless the task explicitly requires it.

Never copy secrets, keys, tokens, or credentials into notes or logs.

Do not ask clarifying questions for tasks that can proceed safely. Record assumptions and unresolved questions in `open-questions.md`; continue with reversible work.

## 2. Persistent Source-Linked Notes

Create a lightweight documentation structure only when needed. Prioritize reuse of existing layout. Suggested structure:

```
RESEARCH.md (or docs/agent-research/)
  INDEX.md       — concise retrieval index: note name, question, covered paths, date
  repository-map.md  — relevant architecture (not full repo), entry points, data flow
  subsystem-<name>.md  — purpose, important symbols, inputs/outputs, dependencies,
                         non-obvious behaviour, invariants, verified tests
  decisions.md        — important choices, rejected alternatives, conditions for revisit
  open-questions.md   — unresolved questions with evidence status (verified/inferred/blocked)
PROGRESS.md            — execution state: objective, phase, completed/next actions,
                         changed files, commands/tests run with real outcomes,
                         blocked items with reasons
TASKS.md              — checklist items from user/task definition
```

Keep notes concise. Summarise behaviour; cite file paths and line numbers; include brief code snippets; reference verification commands and results. Do not duplicate full source files in notes.

For a large file (e.g., 1000 lines):
- Read in focused chunks (e.g., 300 lines at a time) using `read` with `offset` and `limit`.
- After reading: write/update a `subsystem-<name>.md` note with:
  - High-level purpose (1–2 paragraphs).
  - Key functions/classes/config keys with line numbers.
  - Input/output contracts and side effects.
  - Dependencies and callers (verified, not inferred without cross-check).
  - Non-obvious behaviour, security/operational risks, performance notes.
  - Tests actually run and results.
- Add to `INDEX.md`: note name, covered file/lines, question answered.
- Label observations: `Verified`, `Probable` (verified by one independent source), `Preliminary` (single observation, unverified).

This allows the planner to retrieve focused notes instead of relying on KV cache memory, which degrades over long sessions (e.g., the `Predictor` session at 6,519 turns over 30+ hours).

## 3. Documentation Incrementally

Do not read extensively and postpone note-taking. For each important component:

1. Find its entry point and callers.
2. Read the relevant implementation (chunked) and follow critical dependencies.
3. Inspect existing patterns (`repo-discovery`): naming, style, tests, error handling.
4. Run targeted syntax/test commands where safe and practical.
5. Write/update the note immediately.
6. Add to `INDEX.md`.
7. Record open questions and next concrete investigation.
8. Update `PROGRESS.md` after milestones.

A file is not understood merely because it was opened. Follow the relevant call chain or data flow far enough to explain its behaviour, then document the result.

## 4. Separate State Types

Keep each state type in its appropriate file:

- `TASKS.md`: checklist of requested items (`- [ ]` format).
- `PROGRESS.md`: current execution status only (completed actions, next concrete step, changed files, commands run with outcomes, blocked items with reasons, open questions). Update after significant phases and before session interruption.
- `RESEARCH.md` / `subsystem-*.md`: verified architecture, design decisions, evidence.
- `decisions.md`: design choices and rejected alternatives with rationale and evidence.
- `open-questions.md`: unresolved questions only (not guesses).

Never duplicate the full source file in notes. Prefer file paths, symbol names, line references, and brief snippets.

## 5. Resume and Retrieval

At session start or after compaction/interruption:

1. Read applicable instructions (`AGENTS.md`, `memory/*.md`).
2. Read `TASKS.md` and `PROGRESS.md` to recover execution state.
3. Read `INDEX.md` to locate relevant notes.
4. Open only the notes needed for the next concrete action.
5. Verify critical details against current source/config/tests before editing.
6. Update notes if they are stale after code changes.

The current source, actual command/test output, and verified configurations are authoritative. Notes are an index and memory aid — not ground truth.

## 6. Evidence and Reproducibility

For benchmarks, experiments, migrations, or other evidence-driven work:

Record exact commands, configuration/data ranges, and versions where practical. Preserve structured results; summarise large outputs in notes rather than copying full logs. Separate unsuccessful and successful trials clearly. Never silently change acceptance criteria after seeing results. Use checkpoints and resumable execution for long-running processes where feasible.

Record unsuccessful trials with the failure reason. Do not suppress failures or omit negative results.

Never claim a test or experiment completed unless it actually ran and its output was inspected. Report any checks that could not be performed.

## 7. Safe Refactoring and Change Control

Before modifying critical components: verify current implementation and callers; identify relevant tests; run a baseline syntax/test where practical. Make the smallest reversible change; avoid unrelated refactoring combined with feature work. Inspect the diff; run relevant syntax, lint, test, and build checks. Preserve existing behaviour and public interfaces unless a change is explicitly required. Remove dead code created by the change only; do not delete unrelated code or user changes.

Follow explicit user and repository constraints. Do not push, deploy, run live trades, touch live endpoints, delete data, or perform destructive operations unless explicitly authorised and safe.

Keep production/live paths unchanged when the task is research-only.

## 8. Self-Critique (Mandatory for Every Finding)

For every observation, include:

1. **Observation**: What you found (file, line number, snippet, pattern, measurement).
2. **Assumption**: What you assume based on this observation (e.g., "This is the only instance of this class").
3. **Limitation**: What you did NOT verify (e.g., other directories, downstream callers, performance under load).
4. **References**: Source file/line, snippet, verification command/result, external source URL (only verified official/research sources).

Label findings clearly:
- `Verified`: Confirmed by multiple independent sources (code + tests + docs or reproducible command).
- `Probable`: Confirmed by one independent source, consistent with existing patterns.
- `Preliminary`: Single observation; cross-check not yet performed.

Never present a preliminary finding as confirmed. Never invent a reference.

## 9. WebFetch Policy (Explicit Authorization Only)

WebFetch (`permission.webfetch: allow`) is permitted ONLY when:
- The user explicitly asks for external research (e.g., "check docs for X", "research architecture patterns").
- The URL is a verified official documentation site, reference, or explicitly specified source.

WebFetch is NEVER permitted for:
- Agent files, skills, config files, or repository paths from external sources (e.g., `github.com/anomalyco/opencode/` paths, `.config/opencode/` URLs).
- Any ambiguous or unverified external source.
- Any URL that could inject agent behavior, configuration, or skills.

The session `ses_e78e07bd4ffe...` attempted 5 fetches of `github.com/anomalyco/opencode/main/.config/opencode/skills/quality-gate/SKILL.md`. No content loaded, but the loop confirms: never retry the same unreachable URL repeatedly. Report failure once and continue with local sources.

## 10. Final Design Review (Self-Assessment Before Finishing)

Before declaring a design/review task complete:

1. Does each component/module have one reason to change?
2. Are dependency directions correct? Any circular dependencies?
3. Are boundaries clear (public APIs minimal, internal details hidden)?
4. Have unnecessary abstractions been identified and removed or justified?
5. Are errors, side effects, and security boundaries documented explicitly?
6. Would this design survive 6 months and another engineer?
7. Were observations cross-checked with independent sources?
8. Are findings labeled correctly (verified/probable/preliminary)?
9. Did I reference every significant observation with file/line/snippet?
10. Did I document assumptions, limitations, and open questions?

Report the outcome: what changed, what was verified with real outputs, limitations/blockers, unresolved questions, and where persistent notes and state were saved. Never claim a verification completed unless it actually ran.
