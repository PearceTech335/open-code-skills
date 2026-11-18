---
description: Research a file or code section — delegate investigation to the research agent (read-only; writes only the task detail file)
agent: research
---

Investigate: $ARGUMENTS

Read the specified file, function, or pattern and report:
- Line numbers where the target appears
- Relevant code snippets (exact lines)
- Observations: variable names, function signatures, control flow notes
- Any errors or unusual patterns found

DO NOT:
- Propose design changes
- Generate new code
- Make decisions about what should change
- Write to any file except the assigned `tasks/<id>.md` `## Research` section (only when one exists and you were told to fill it)

Every path and line number must be copied from a tool result in this session. The planner (the configured model in `opencode.json`) reviews your findings and decides next steps.