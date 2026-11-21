---
description: Rigorous multi-stage orchestration for local models or high-stakes work (research → decomposition → adversarial review → planning → implementation → review → test → sign-off). Forces full quality pipeline every step. Use when token usage is acceptable and code quality/integrity is paramount. Can be invoked as @rigour subagent.
agent: rigour
---

# @rigour — Subagent Notation

This subagent enforces the full rigour quality pipeline for every task. Invoke with `@rigour <task goal>` to activate the 9-stage pipeline: research → decomposition → adversarial review → planning → implementation → review → test → sign-off.

- Shares same agents and templates as autopilot
- Same specialist agents (`coder`, `research`, `review`, `test`) are reused
- State files (`TASKS.md`, `tasks/`, `CURRENT_STATE.md`) shared with autopilot mode