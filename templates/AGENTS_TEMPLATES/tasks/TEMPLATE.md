# Task <id> — <title>

> Copy this file to `tasks/<id>.md` when the task is picked up. Keep
> `TASKS.md` as the one-line index; this file holds all depth. When the
> operator reviews a ticked task, THIS is the only file they need to open.

Status: <NOT_STARTED | IN_PROGRESS | BLOCKED | DONE>
TASKS.md line: <exact one-liner from TASKS.md>
Attempts: memory/learning/tasks/<id>-attempts.jsonl (deleted on resolution)

## Goal
<one sentence: what "done" means for the user>

## Acceptance criteria
- [ ] <criterion 1 — testable>
- [ ] <criterion 2 — testable>

## Scope
- In: <files/modules this task touches>
- Out: <explicitly not part of this task>

## Research (research agent fills before implementation)
### Findings
- <claim> — evidence: <file:line | command output> — label VERIFIED/INFERRED/UNKNOWN

### References
- <file:line, docs URL + access date, command run>

### Open questions / assumptions
- <what is unknown, what was assumed, what would verify it>

## Implementation notes
- <approach taken, files changed, key decisions>

## Testing criteria
- [ ] <test command → expected result>
- [ ] <regression check → expected result>

## Attempts (one line per try; mirror attempts.jsonl)
1. <date> <what was tried> → <result: pass/fail + one-line reason>

## Review verdict (planner appends after `review` subagent)
1. Correctness: PASS/FAIL — <one-line reason>
... (all 10 axes from `review` agent checklist)
LEARNING_BRIEF emitted: <yes/no + path>

## Final outcome
- Ticked in TASKS.md: <date> by <agent/human>
- metrics.jsonl line appended: <yes/no>
- Remaining risks / follow-ups: <none or list>
