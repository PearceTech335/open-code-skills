# Autopilot Invocation Template (Quality-Control Orchestrator)

Use this template when switching to the `autopilot` agent. It drives the full
"how a software dev would do it" loop, one task at a time, for small local
(9B-class) models. Fill in the bracketed sections.

## MISSION
[The operator's goal: either work the existing TASKS.md list to completion,
or merge the following request into TASKS.md as a new milestone and work it.]

## ENTRY MODE — decide first
- **Mode A (resume)** — the request refers to the existing list ("continue",
  "resume", "finish the tasks", "do the tasks", or no new goal). Do not create a
  new list; repair missing `tasks/<id>.md` skeletons; start at the first
  unchecked item.
- **Mode B (new goal)** — the request assigns a goal. Merge it into
  `TASKS.md` as a new milestone (3–12 verifiable items, `- [ ] <id> — <task>
  → tasks/<id>.md`); append only; never rewrite the existing list.

Never create a parallel ledger (`TODO.md`, `TASKS-2.md`). Backlog untouched.

## PER-TASK LOOP (repeat for every unchecked root item)
1. **Repo lookup** — read `memory/PROJECT_INDEX.md` (create/verify it first if
   missing/stale), `memory/CURRENT_STATE.md`, the target entry points and
   adjacent tests. Evidence, not memory.
2. **Pick the task** — first unchecked item in the active milestone; read
   `tasks/<id>.md`; fill Goal + Acceptance criteria if thin. Blocked task →
   record + skip.
3. **Research** — `--agent research`, writing only the `## Research` section:
   existing patterns/call sites, file targets, flow-corruption risk, security
   risk, explicit blockers, smallest robust implementation shape.
4. **Plan** — ≤5 files; what will NOT change; the failure mode you're
   preventing. Split bigger work into its own detail files.
5. **Implement** — `--agent coder` with this plan; Power-of-10-inspired bar
   (simple flow, bounded ops, small functions, explicit errors, validated
   input, no dead/duplicate code, comments on non-obvious intent).
6. **Review** — `--agent review` adversarial; 10-axis PASS/FAIL + complexity
   critique + security pass. Any FAIL → fix → re-review (max 2 rounds).
7. **Test** — `--agent test` targeted → regression → broader suite, explicit
   timeouts. Failure → bounded fix loop: review classifies → research digs →
   coder fixes → retest (max 3 iterations).
8. **Document** — fill `tasks/<id>.md` (change + review verdict + test
   evidence + risks), update `memory/CURRENT_STATE.md` (and `DECISIONS.md` /
   `ARCHITECTURE.md` / `PROJECT_INDEX.md` when relevant), set `Status: DONE`,
   tick `TASKS.md`, commit, append heartbeat to `PROGRESS.md`.
9. **Next task** — repeat until the root milestones are done or a hard blocker
   stops the run.

## CONSTRAINTS
- One task at a time; never write code yourself (use `coder`) except trivial
  fixes you verify by running.
- Evidence only: observed command output; paths/line numbers copied from tools.
- No weakening acceptance criteria; no disabling/silencing tests.
- Reads ≤150 lines; treat the checkpoint as ground truth — do not re-read.
- Subagents cannot delegate further (depth 1).
- `MISSION.md` and `TASKS.md` structure are never rewritten; tick only.
- Log attempts to `memory/learning/tasks/<id>-attempts.jsonl`; `LEARNING_BRIEF`
  only for knowledge gaps (self-help loop).

## REQUIRED OUTPUT (all sections non-empty)
1. **Mode** — A or B, and how you determined it.
2. **Tasks completed** — IDs, with the verification command + observed result each.
3. **Tasks blocked** — ID, blocker, evidence, what would unblock it.
4. **Fix iterations** — for any failed test: how many, root causes, fixes.
5. **Files changed** — path list.
6. **Docs updated** — which files, why.
7. **`PROGRESS.md`** — written; one-line user summary.
8. **Remaining work** — next unchecked item, or "complete".
