# Rigour Invocation Template (High-Integrity Orchestrator)

Use when invoking `@rigour` to complete `TASKS.md` with verified, tested code. Fill in the bracketed sections.

## MISSION

[Work the existing `TASKS.md` to completion with full rigour, or merge this request into `TASKS.md` as a new milestone and work it: <goal>.]

## ENTRY MODE — decide first

- **Mode A (resume):** the request refers to the existing list ("continue", "resume", "finish"). Start at the first unchecked eligible item.
- **Mode B (new goal):** merge into `TASKS.md` as a new milestone (3–12 independently verifiable items, append only) and create `tasks/<id>.md` files.

## RIGOUR PIPELINE (mandatory for every task)

0. **Bootstrap:** read `AGENTS.md`, `memory/PROJECT_INDEX.md`, `memory/CURRENT_STATE.md`, `TASKS.md`. Rebuild a missing/stale index before proceeding.
1. **Research:** invoke `research` with `templates/subagent-calls/research.md`. It writes `tasks/<id>.md` `## Research` (implementation, architecture fit, blockers, alternatives).
2. **Decomposition:** break the task into researched subtasks; create `tasks/<subtask-id>.md` as needed.
3. **Adversarial review of research:** invoke `review`; require PASS/FAIL with evidence before planning.
4. **Planning:** record files (≤5), doc updates, security notes, and test strategy in `tasks/<id>.md`.
5. **Implementation:** invoke `coder` with `templates/subagent-calls/coder.md`; smallest coherent change; tests where required.
6. **Review:** invoke `review` on the actual diff; 10-axis + Power-of-10 + security; read-only; fresh review after every fix.
7. **Test:** invoke `test` with `templates/subagent-calls/test.md`; static → build → targeted → regression → integration → security → broader suite; capture commands, exit codes, and the exact observed output in `tasks/<id>.md`.
8. **Sign-off:** load `quality-gate`; for multi-subtask/overnight runs load `supervisor` and tick only on CONTINUE/STOP-SUCCESS. Verify acceptance criteria, update docs, set `Status: DONE`, tick `TASKS.md`, update `memory/CURRENT_STATE.md`, commit only after review/test/quality-gate PASS.
9. **Next task:** select the next unchecked eligible task and repeat from step 1.

## CONSTRAINTS

- Do not self-approve. `review` and `test` are independent and read-only.
- Do not weaken acceptance criteria to make a test pass.
- Evidence only: observed command output; `file:line` copied from tools.
- Failure budget: investigate/correct → deeper research → reconsider approach → BLOCKED. Track `memory/learning/tasks/<id>-attempts.jsonl`; summarize to `memory/learning/metrics.jsonl` on resolution.
- Hard blockers: destructive migrations, credential changes, production deployments, security-boundary changes. Stop and report.

## REQUIRED OUTPUT (all sections non-empty)

1. **Mode** — A or B and how it was determined.
2. **Tasks completed** — IDs, verification commands, observed results.
3. **Tasks blocked** — ID, blocker, evidence, what would unblock.
4. **Fix cycles** — failure type, root cause, fix, outcome.
5. **Docs updated** — files and why.
6. **Files changed** — list.
7. **`PROGRESS.md`** — written; one-line summary.
8. **Remaining work** — next eligible task or "complete".
