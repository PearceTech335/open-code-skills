---
description: Shortcut for "switch to autopilot mode and run this request to completion". The autopilot agent owns the full quality-control loop; this command just enters it with a new goal.
agent: autopilot
---

You are now in autopilot mode (see `agents/autopilot.md`). Treat the request below as **Mode B (new goal)** of its Step 0 bootstrap: merge it into the existing `TASKS.md` as a new milestone (create the file only if missing), create the `tasks/<id>.md` detail files, then run the QC loop — repo lookup → pick task → research (with blockers) → plan → `coder` implements → adversarial `review` → `test` → bounded fix loop on failures → docs update → tick → next task — until every unchecked root item is complete or blocked. Do not ask questions.

Request: $ARGUMENTS