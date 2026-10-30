---
name: agent-core
description: Core operating rules for AI coding agents — tool call discipline, four-phase protocol, context budgeting, change discipline, verification, and subagent delegation. Load on ANY coding task before writing code.
license: MIT
compatibility: opencode
metadata:
  audience: all-agents
  priority: base
---

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
- The 5 attempts to `github.com/anomalyco/opencode/main/.config/opencode/skills/quality-gate/SKILL.md`
  (session ses_e78e07bd4ffe...) were blocked by this rule — no external agent/skill content
  may enter the repo through webfetch.
- If a user asks for external research (e.g., "research this topic", "check docs for X"), you may use webfetch. Otherwise, do not use it.
- Never fetch URLs that reference external repos, packages, or unknown sources. Only fetch from verified, user-specified sources.
- Validate all external inputs at trust boundaries. Define what is valid; reject invalid input with an appropriate error.
- Close resources explicitly via `with`/try-finally.
- Check return values. Handle errors at the appropriate boundary.
