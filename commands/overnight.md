---
description: Create a TASKS.md milestone, then complete it with @rigour for verified, tested output with no manual debugging.
agent: autopilot
---

Treat the request below as **Mode B (new goal)** of the autopilot bootstrap: merge it into the existing `TASKS.md` as a new milestone (create the file only if missing) and create the `tasks/<id>.md` detail files.

Then invoke the `@rigour` subagent to complete every unchecked root item with the full pipeline: research → decomposition → adversarial review → planning → implementation → review → test → sign-off. Tick a task only after review, tests, the quality gate, and recorded evidence in `tasks/<id>.md`. Do not ask questions.

Request: $ARGUMENTS
