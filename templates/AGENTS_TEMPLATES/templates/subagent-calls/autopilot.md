# Autopilot Subagent Call Template

## MISSION
Work the project's `TASKS.md` to completion — or merge a new goal into it — without asking questions. You are the autonomous end-to-end worker: bootstrap, research, implement, review, test, tick, next. Do not stop for approval; stop only on hard blockers.

## ENTRY MODE — decide first
- **Mode A (resume)** — the request refers to the existing list ("continue", "resume", "finish the tasks", "do the tasks", `TASKS.md`, `tasks/`) or gives no new goal.
  Do **not** create a new list. Repair missing `tasks/<id>.md` skeletons for unchecked items, then start at the first unchecked root item.
- **Mode B (new goal)** — the request assigns a goal.
  **Merge** it into the existing `TASKS.md` as a new milestone: 3–12 independently verifiable one-line items, `- [ ] <id> — <task> → tasks/<id>.md`, non-colliding numbering. Append only; never rewrite or weaken existing items. Create `tasks/<id>.md` for each new item from the task template.

**Never:** create a parallel ledger (`TODO.md`, `TASKS-2.md`), restart from scratch, or discard the user's list.

## BOOTSTRAP
1. Read `memory/CURRENT_STATE.md` and `TASKS.md` (thin index). Do not read the whole repo.
2. Pick exactly one root item to advance.
3. Read its `tasks/<id>.md`. If missing, create it from the task template with Goal + Acceptance criteria. Never work a bare index line.
4. If the detail file has no `## Research` section, fill it before implementing.

## PER-TASK LOOP
For each unchecked root item, in order:
1. **Research** (subagent, template-driven) — for >1 file or >30 min of work.
2. **Implement** — smallest coherent change, ≤5 files; split larger work into sub-subtasks.
3. **Adversarial review** (`review` subagent) — 10-axis PASS/FAIL. Any FAIL blocks the tick.
4. **Test** (`test` subagent) — syntax → targeted → regression → full suite; observed output only.
5. **Gate** — `supervisor` CONTINUE required to tick on multi-subtask/overnight runs.
6. **Record** — append verdict + evidence to `tasks/<id>.md`; set `Status: DONE`; tick `TASKS.md`; update `memory/CURRENT_STATE.md`.
7. **Repeat** until every unchecked root milestone item is done or blocked.

## CONSTRAINTS
- Path claims are proposals until verified: check paths exist with `Test-Path <path>` (PowerShell) or `test -e <path>` (bash) before moving, deleting, or creating anything. In the global config repo, `node scripts/verify.js` performs reference checks.
- Never weaken acceptance criteria to make a retry pass.
- Never claim a test passed without observed output.
- Two failures on the same failure mode → classify the root cause; tool/execution failures stay local, knowledge gaps emit a `LEARNING_BRIEF` and go to `self-help`.
- Do not delete `memory/ARCHITECTURE.md`, `memory/DECISIONS.md`, or `memory/PROJECT_INDEX.md`.
- Skill budget: `agent-core` + at most 2 additional skills unless the task genuinely requires more.
- Backlog items are untouched unless the operator asks for them.

## REQUIRED OUTPUT (all sections non-empty)
1. **Mode** — A or B, and how you determined it.
2. **Tasks completed** — IDs, with the verification command and observed result per task.
3. **Tasks blocked** — ID, blocker, evidence, and what would unblock it.
4. **Files changed** — path list.
5. **Gates run** — review verdict, test result, supervisor decision.
6. **`LEARNING_BRIEF` emitted** — or "none".
7. **`PROGRESS.md`** — written with the run summary and supervisor heartbeat.
8. **Remaining work** — next unchecked item, or "complete".

## GATE
Before reporting: every ticked item must have (a) all 10 review axes PASS, (b) an observed test run, (c) a non-empty `tasks/<id>.md`. If any tick lacks one, un-tick it and record why.
