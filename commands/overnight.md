---
description: Turn a request into TASKS.md, then start unattended work on it
agent: autopilot
---

Create or update `TASKS.md` in the project root from this request, then start working immediately.

Request: $ARGUMENTS

Rules:

- Break the request into 3-12 independently verifiable checklist items, each written as `- [ ] ...`.
- Each item must be small enough to complete and verify in one pass.
- Add a final item that records the verification command used and its result.
- Then take the first unchecked item and work it. Do not ask questions.
