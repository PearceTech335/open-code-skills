---
name: supervisor
description: Lightweight process supervisor for long-running agentic work. Monitors TASKS.md + CURRENT_STATE.md + PROGRESS.md, detects drift/stalls/self-approval, enforces budgets, and decides continue / replan / escalate / stop. Load on every multi-stage or overnight run.
license: MIT
compatibility: opencode
metadata:
  audience: planner-agent, autopilot
  priority: high
---

# Supervisor Skill

File-only process judge for multi-subtask, context-reset, or unattended runs. It does not implement features and is not a second reviewer — its delta over `review` is cross-item goal alignment and stall/budget detection. Load conditionally (multi-subtask runs only), never unconditionally.

## When to Invoke

- Start of every overnight/autopilot session.
- After each completed sub-subtask (tick event in TASKS.md).
- After any LEARNING_BRIEF emission or attempt-3 stop.
- Before declaring a milestone group done (last unchecked TASKS item in the group ticked).

## Required Inputs (in order)

1. `PROJECT_INDEX.md` (if present) → 2. `memory/CURRENT_STATE.md` → 3. `TASKS.md` → 4. `PROGRESS.md` → 5. Original high-level request → 6. Any open LEARNING_BRIEF/blocker notes. Files are authoritative; do not rely on conversation history.

## Core Decision Loop

Answer each with evidence (`file:line` or exact command output):

1. **Goal Alignment** — Active item maps to the original request. FAIL = scope creep, rewritten criteria, abandoned intent.
2. **Progress** — Verifiable leaf completed since last heartbeat (checkbox flipped + CURRENT_STATE updated + verification evidence). STALL = same item at attempt 3 with no new evidence (template §3.5 budget). REGRESS = completed item now broken.
3. **Verification Integrity** — Concrete commands + observed output required. FAIL = natural-language self-approval, "should work", skipped tests.
4. **Budget** — Per-sub-subtask 3-strike attempts (template §3.5) is the sole budget; per-run `max-new-skills-per-run: 3`. Crossing → forced review or escalate. No round counters.
5. **Drift Signals** — Invented APIs, weakened criteria, unevidenced claims, repeated identical failure without LEARNING_BRIEF, raw tool output still unspilled in context.

## Decision Outcomes

Emit exactly one, with one-line rationale + evidence:

- `CONTINUE` — healthy; proceed to next open leaf item.
- `REPLAN` — recommend rewrite of the affected TASKS.md section only; the planner edits, never completed items, never the supervisor.
- `ESCALATE` — hard blocker, repeated structural failure, or budget exceeded; write blocker note + evidence, stop or hand to human (interactive runs). In autopilot, use Unattended Mode below instead.
- `STOP-SUCCESS` — all acceptance criteria met, final verification item passed, PROGRESS.md updated.
- `STOP-FAILURE` — cannot proceed without violating constraints; document why.

Never invent a sixth outcome.

## Unattended (Autopilot) Mode

In autopilot/overnight runs supervisor decisions are final — never pause for approval:

- `CONTINUE`/`REPLAN` execute immediately (planner edits the affected TASKS.md section only).
- `ESCALATE` records blocker + evidence to `CURRENT_STATE.md`/`PROGRESS.md`, marks/splits the item, moves on; human review deferred to post-run audit (`PROGRESS.md`, `metrics.jsonl`, provisional skills).
- `STOP-FAILURE` only on hard blockers (missing index, broken endpoint, unrecoverable error, budget exhausted across all remaining items).
- Skills stay provisional per §6; supervisor never approves skills — post-run audit, not a mid-run pause.

## Heartbeat Protocol

After each sub-subtask decision, append one line to `PROGRESS.md` (never `metrics.jsonl` — its one-line-per-sub-subtask invariant on resolution is unchanged):

`[<ISO-8601 timestamp>] task_id=<mN-tN-stN-ssN> decision=<CONTINUE|REPLAN|ESCALATE|STOP-SUCCESS|STOP-FAILURE> evidence=<file:line|exact command>`

## Guardrails

- No feature implementation; no editing source files, TASKS.md, or CURRENT_STATE.md (read-only judge; planner edits).
- Never weaken acceptance criteria; never extend the 3-attempt budget; never approve a skill (human gate per `self-help`).
- No invented outcomes, APIs, or evidence. If inputs are missing, label PRELIMINARY and escalate rather than guess.
