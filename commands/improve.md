---
description: Research a missing domain/skill, generate a validated SKILL.md draft, and hold it for the review gate before activation
agent: autopilot
---

Research the following missing skill/domain: $ARGUMENTS

Follow the `self-help` skill protocol:
1. Verify it is a systemic gap, not a one-off bug.
2. Gather verified best practices (local codebase patterns or official docs).
3. Draft the `SKILL.md` under `.opencode/skills/<skill-name>/SKILL.md` (project scope) or `~/.config/opencode/skills/<skill-name>/SKILL.md` (global — only with explicit operator request for global promotion).
4. Do NOT edit `AGENTS.md` or memory files automatically. Report what would need to change and let the operator approve.
5. Present the draft to the user and STOP — do not activate it. The `self-help` Learning Gate and the human review gate must pass before activation.