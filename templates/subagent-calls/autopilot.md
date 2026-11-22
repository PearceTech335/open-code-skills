# Autopilot Invocation Template (Lightweight Orchestrator)

Use when switching to the `autopilot` agent. It runs a light loop for capable models: bootstrap → light discovery → direct implementation or one coder call → optional review/test → acceptance. For verified, high-integrity completion of `TASKS.md`, invoke `@rigour` instead. Fill in the bracketed sections.

## MISSION

[Either work the existing `TASKS.md` list to completion, or merge this request into `TASKS.md` as a new milestone and work it: <goal>.]

## ENTRY MODE — decide first

- **Mode A (resume):** the request refers to the existing list ("continue", "resume", "finish", or no new goal). Start at the first unchecked eligible item; leave the backlog untouched.
- **Mode B (new goal):** merge into `TASKS.md` as a new milestone (3–12 items, `- [ ] <id> — <task>`); append only; never rewrite the list; create `tasks/<id>.md` files.

## PER-TASK LOOP

0. Read `AGENTS.md`, `memory/CURRENT_STATE.md`, `TASKS.md`; select the next unchecked task.
1. Read the task detail file and only the source files it needs. Use `repo-discovery` if structure is unclear.
2. Implement directly, or delegate one coherent change to `coder`.
3. If the change is non-trivial or high-risk, invoke `review`; if verification is required, invoke `test`. Otherwise proceed on internal verification.
4. Update documentation only if behaviour changed; record brief findings in `tasks/<id>.md`.
5. Accept when the implementation matches the plan, review/test passed (if invoked), docs match behavior, and the git tree is clean. Set `Status: DONE`, tick `TASKS.md`, update `memory/CURRENT_STATE.md`.
6. Select the next eligible task and repeat.

## ESCALATE TO @rigour

Invoke `@rigour` when the operator asks for the full pipeline, or when the task is ambiguous, high-risk, or must be completed with verified, tested output and no manual debugging.

## CONSTRAINTS

- One task at a time; specialists run sequentially.
- Evidence only: observed command output and `file:line` from tools.
- Reads ≤150 lines per call; treat the checkpoint as ground truth.
- Hard blockers: destructive migrations, credential changes, production deployments, security-boundary changes.

## REQUIRED OUTPUT

1. Mode (A/B) and why.
2. Tasks completed (IDs + verification).
3. Tasks blocked (reason + what would unblock).
4. Files changed.
5. `PROGRESS.md` written; one-line summary.
6. Remaining work.
