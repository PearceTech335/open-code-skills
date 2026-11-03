---
name: agent-core
description: Core operating rules for AI coding agents — tool call discipline, four-phase protocol, context budgeting, change discipline, verification, and subagent delegation. Load on ANY coding task before writing code.
license: MIT
compatibility: opencode
metadata:
  audience: all-agents
  priority: base
---

## Skills Inventory Protocol (before any coding task)

Before writing code, verify which skills apply:

1. Load `agent-core` (this file) — mandatory on any task.
2. Inspect available skills: list `skills/` (global) + `.opencode/skills/` (project). Read relevant `SKILL.md` files only when their domain matches the current file/module/task.
3. Load the language/domain skill matching the file (`python-code`, `go-code`, `typescript-code`, etc.). If no language skill matches the codebase, load `repo-discovery` first.
4. Load meta/quality skills when their guidance is needed (`readable-code`, `designer`, `quality-gate`).
5. Load `long-running-task-research` for large-file edits or multi-module refactors.
6. Load `self-help` **only** when a failure survives a second correction attempt on a knowledge gap (`AGENTS.md` §5). Never invent a missing skill; never load `self-help` for a trivial `IMPLEMENTATION_DEFECT`.
7. Load subagent specs (`reviewer.md`, `research.md`, `coder.md`) only when the planner explicitly invokes them (`--agent` / agent invocation); they inherit `model` and work independently.
8. Report which skills were loaded in your response or `RESEARCH.md`. If none matched and you needed a new capability, document the gap; do not invent APIs or skills.

Do not load unrelated skills (e.g., `bash-skill` for a Python module, `security` for a simple UI edit) — unnecessary context bloat degrades reasoning.

## Tool Call Discipline

Call tools directly in `<tool_use>` blocks. Never describe them as text. Keep user-facing explanations proportional to the task — enough detail to explain important design choices, verification results, and limitations.

## Four-Phase Protocol

1. **Explore** (read-only) — grep/glob for the relevant path, trace data flow, identify conventions. List files that will and will not change.
2. **Plan** — 2–5 bullets naming every file that will change. Split >5-file changes into sub-tasks.
3. **Execute** — smallest coherent change. Preserve APIs. No new dependencies without approval.
4. **Verify** — syntax → lint → targeted tests → full build → adversarial self-review. Show evidence, never assert.

## Execution and Verification

1. Explore the relevant code and understand existing conventions.
2. Make the smallest coherent change that meets the requirements.
3. Run the relevant syntax checks, tests, and other project checks.
4. Review the diff for correctness, readability, security, and scope.
5. Report what changed, what was verified, and any remaining risks.

Do not stop immediately after writing code. Complete the verification steps that are practical in the current environment.

If a check fails, diagnose the cause before deciding whether to retry, fix the issue, use an alternative check, or report a blocker. Do not retry blindly.

## Hallucination Prevention

- Inspect the project's definitions, documentation, or installed package interfaces whenever correctness depends on an API detail you cannot establish confidently.
- Verify parent directories exist before creating files.
- Never fabricate interfaces or behaviour — read actual definitions.

## Context Budget

- Prefer the smallest safe change. Use narrow grep/glob, not speculative reads.
- Avoid reading and summarising the entire repository when only a small, well-understood area needs modification.
- Clear context between unrelated tasks. Long sessions degrade accuracy.
- Delegate investigation-heavy reads to sub-sessions.

## Course-Correction

- If a verification step fails, diagnose the cause before deciding whether to retry, fix, use an alternative, or report a blocker.
- If corrected for the same mistake more than twice, restart with a clearer prompt.
- If requirements conflict with existing code, surface the conflict immediately.

## Security

- No hardcoded secrets, keys, or credentials. Use environment variables.
- WebFetch (`permission.webfetch: allow`) is permitted ONLY for:
  1. Explicit user-requested research (e.g., "check docs for X", "research this API")
  2. Verified external documentation (official docs, reference sites)
- NEVER use webfetch to load agent files, skills, config files, or anything
  from repositories like `github.com/anomalyco/opencode/`, `raw.githubusercontent.com`,
  or any `.config/opencode/` path from the internet.
- If a user asks for external research (e.g., "research this topic", "check docs for X"), you may use webfetch. Otherwise, do not use it.
- Never fetch URLs that reference external repos, packages, or unknown sources. Only fetch from verified, user-specified sources.
- Validate all external inputs at trust boundaries. Define what is valid; reject invalid input with an appropriate error.
- Close resources explicitly via `with`/try-finally.
- Check return values. Handle errors at the appropriate boundary.

## Small-Model Guardrails (when model_tier == small)

- **Skill-count cap**: Load at most 2 skills per task. If more are needed, split the task into sub-tasks.
- **Stop-and-ask threshold**: If you cannot verify an assumption with a single file read or command, label it PRELIMINARY and stop. Do not proceed on unverified assumptions.
- **Deep research**: Read PROJECT_INDEX.md first. Break task into sub-tasks in TASKS.md using IDs (mN-tN-stN-ssN). Each sub-task gets its own attempt file.
- **Compact output**: Use compact Learning Brief (4-field) instead of full 8-field. Use PASS/FAIL checklist for reviews.
- **Temperature**: Set per agent role: planner 0.1-0.3, coder 0.2, research 0.4, reviewer 0.1.

## Planner vs Execution Model Divergence

- Planner (opencode.json model) runs on the free/cloud endpoint (e.g., MiMo-2.6). All planning, root-cause classification, LEARNING_BRIEF emission, and approval decisions use this endpoint only.
- Subagent execution (coder, research, reviewer, autopilot) must route through the local endpoint (declared in opencode.json as the local provider) for all writes, reads, edits, tests, and diffusion steps. The planner never passes subagent execution to the cloud endpoint.
- Rationale: planner token budget is limited (daily allowance); execution token budget is unbounded (local GPU). Enforce this split at every subagent invocation.
- If subagent execution needs a different model for a specific task, declare it in the subagent spec (execution_model) rather than overriding the planners model.
