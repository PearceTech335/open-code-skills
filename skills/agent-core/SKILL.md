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
3. **Load `repo-discovery` whenever the target file or subsystem has not been read in this session** — regardless of which language skill matches. It defines the discovery procedure; do not skip it because a language skill exists.
4. Load **one** language/domain skill matching the primary file (`python-code`, `go-code`, `typescript-code`, `powershell-skill`, `bash-skill`, or a domain skill).
5. Load **at most one** workflow/meta skill when its trigger applies: `readable-code` (new code), `designer` (component/interface design), `quality-gate` (final review), `long-running-task-research` (multi-stage/overnight work). Total additional skills beyond `agent-core`: **2**.
6. Load `self-help` **only** when a failure survives a second correction attempt on a knowledge gap (see the global `## Learning Loop` section; project template §5). If the 2-skill cap is already used, split the task instead of loading more. Never invent a missing skill; never load `self-help` for a trivial `IMPLEMENTATION_DEFECT`.
7. Load subagent specs (`review.md`, `research.md`, `coder.md`) only when the planner invokes them. Subagents inherit the configured model unless their frontmatter sets `model:`. **Delegation depth is configured by `subagent_depth`** (currently `2` in `opencode.json`). An orchestration subagent such as `rigour` may invoke specialist subagents; specialists (`coder`, `research`, `review`, `test`) must not delegate further. A subagent that needs a capability beyond the configured depth reports the gap to its caller.
8. Report which skills were loaded in your response or the task detail file. If none matched and you needed a new capability, document the gap; do not invent APIs or skills.

Do not load unrelated skills (e.g., `bash-skill` for a Python module, `security` for a simple UI edit) — unnecessary context bloat degrades reasoning.

## Tool Call Discipline

Call tools directly in `<tool_use>` blocks. Never describe them as text. Keep user-facing explanations proportional to the task — enough detail to explain important design choices, verification results, and limitations.

## Four-Phase Protocol

1. **Explore** (read-only) — grep/glob for the relevant path, trace data flow, identify conventions. List files that will and will not change. **Requirements micro-checklist (always):** (1) Goal/acceptance criteria explicit? If not, clarify or label `PRELIMINARY`. (2) Verify existing behavior by reading target file + relevant tests/call sites. (3) Check API/contracts/schema impact. (4) Check alignment with `PROJECT_INDEX.md`/`ARCHITECTURE.md`. (5) Escalation triggers (cross-module/boundaries/deps/schema/unclear ownership/ambiguous requirements)? If yes, escalate to `architect` subagent or `research` subagent per escalation rules. Pay a little upfront to avoid future refactors.
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

- Prefer the smallest safe change. Use narrow grep/glob with line limits, not speculative reads.
- **Read files in slices of ≤150 lines** using `offset`/`limit` (the tool-output cap is 200 lines). If a result is truncated or ends mid-construct, re-read from the last received line before drawing conclusions.
- Treat file contents already summarized in the checkpoint/recent context as read — do not re-read them.
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

## Guardrails

- **Skill-count cap**: `agent-core` is mandatory and is **not counted** toward the skill cap. Load at most **2 additional skills** per task beyond `agent-core` (typically 1 language/domain + 1 workflow skill). If more capabilities are needed, split the task into sub-tasks or delegate to subagents/templates/checklists rather than loading extra skills. Specialists report capability gaps to the orchestrator instead of delegating further.
- **Evidence discipline**: every file path and line number you report must be copied from a tool result in this session. Label claims `VERIFIED` (tool output/file read), `INFERRED` (one source or indirect), or `UNKNOWN` (not established). Never present an inferred or guessed path as verified.
- **Stop-and-ask threshold**: If you cannot verify an assumption with a single file read or command, label it PRELIMINARY and stop. Do not proceed on unverified assumptions.
- **Deep research**: Read the project index (`memory/PROJECT_INDEX.md`) first. Break task into sub-tasks in TASKS.md using IDs (mN-tN-stN-ssN). Each sub-task gets its own attempt file and its own `tasks/<id>.md` detail file (research/scope/references/testing/pass-fail all live there).
- **Compact output**: Use compact Learning Brief (4-field) instead of full 8-field. Use PASS/FAIL checklist for reviews.
- **Temperature**: Set per agent role: planner 0.1-0.3, coder 0.2, research 0.4, review 0.1. Do not add sampling parameters beyond `temperature` in agent frontmatter — none (e.g. presence/frequency penalty, thinking toggles) are supported by the current providers.

## Model Routing

- `opencode.json` declares a single `model`; all agents inherit it unless the agent frontmatter sets `model: <provider/model>`.
- Do not assume a cloud/local split or an `execution_model` key. Neither exists in this configuration. If a different model is needed for a subagent, set the documented `model:` field.
- If the deployment does split planner and execution endpoints, document that in `opencode.json` and the project's `AGENTS.md` — do not rely on undocumented keys.

## Subagent Invocation Templates

When invoking a subagent, use the corresponding template from templates/subagent-calls/:
- research.md -- investigation/discovery/decision research (unified template: evidence-first, adversarial review, references)
- review.md -- code review tasks
- coder.md -- code generation tasks
- autopilot.md -- lightweight orchestrator for capable models (bootstrap, light discovery, direct implementation, optional review/test, acceptance, tick)
- rigour.md -- high-integrity orchestrator for completing TASKS.md with verified, tested code (research -> decomposition -> adversarial review -> planning -> implementation -> review -> test -> sign-off); delegates to coder/research/review/test

Fill in the bracketed sections. If no template exists, create one via self-help (section 7.5) before invoking.
Templates ensure the model receives a structured, complete prompt rather than an ad-hoc one.

## Subagent Output Verification

When a subagent returns a report, verify before using:
1. Mandatory answer: did it state the direct answer to the mission question?
2. Evidence: every factual claim (line numbers, counts, paths) must have an attached command/file reference.
3. No empty sections: every required section must contain content.
4. Cross-check: confirm key findings with at least two independent sources.
Do not trust subagent claims blindly — small models produce reports that look correct but may contain unverified specifics.

## Research Decomposition (vague prompts)

When the operator gives a vague or broad research prompt, do NOT attempt to answer it in one pass:
1. Broad-brush scan (quick, shallow): identify major areas, files, and questions. Output a list of sub-questions, not a full report.
2. Decompose: break into 3-5 specific, targeted sub-questions. Each answerable with a focused file read or command.
3. Targeted research: invoke the researcher for each sub-question with a specific prompt using templates/subagent-calls/research.md (unified). Each prompt answers ONE question.
4. Synthesize: after all sub-researchers return, synthesize findings into the final report. The planner (not the sub-researchers) does the synthesis.
This ensures each researcher call is focused and verifiable, rather than one massive vague prompt that produces unverified claims.

## Subagent Invocation Reference

- --agent research: loads agents/research.md (fast file parser, discovery)
- --agent review: loads agents/review.md (adversarial review, LEARNING_BRIEF emitter)
- --agent coder: loads agents/coder.md (code generation subagent)
- --agent autopilot: loads agents/autopilot.md (lightweight orchestrator for capable models: bootstrap, light discovery, direct implementation, optional review/test, acceptance, tick - used as a primary agent via the agent switch, not a subagent)
- --agent rigour: loads agents/rigour.md (high-integrity orchestrator: research, decomposition, adversarial review, planning, coder, review, test, sign-off; invoked as `@rigour` and may delegate to specialists at depth 2)
- network-engineer: load skill `skills/network-engineer/SKILL.md` (OT/network troubleshooting). Prefer subagents only when escalation needs investigation orchestration; otherwise use the skill to conserve slots.
The template file (templates/subagent-calls/) provides the structured prompt; the agent spec (agents/) provides the role definition. Both must match.
