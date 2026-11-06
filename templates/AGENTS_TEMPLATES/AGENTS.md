# <PROJECT_NAME> — Agent Instructions

> This file layers **project-specific** rules on top of the GLOBAL agent config
> (`~/.config/opencode/AGENTS.md` + global skills). Global rules still apply and
> are NOT replaced here: Engineering Standards (workflow, principles, verification,
> behaviour), the skill hierarchy, security/WebFetch policy, language tool mapping,
> and the global Learning Loop pointer. This file adds the project's workflow,
> knowledge layout, and the self-improving Skill Policy. It does NOT repeat
> global content — it only adds what is specific to this project.

## 1. Mission

<One or two sentences: what this project is, and its priorities in order.
Example: "Build and maintain X.">

Priorities:
1) correctness
2) data integrity
3) testability
4) performance
A passing test suite does not by itself
establish correctness.

## 2. Mandatory Task Startup (Checklist)

Before any work: `PROJECT_INDEX.md` → `CURRENT_STATE.md` → `TASKS.md`.
If index missing/stale: load `project-index` (and `repo-discovery` if needed), inspect, update/create index first.

For non-trivial tasks (consolidated flow):
1. Inspect implementation / load `repo-discovery`.
2. Set acceptance criteria.
3. Identify affected modules + tests.
4. Load language/domain skill; plan smallest coherent change.
5. If complex: invoke `--agent research` (structured prompt only).
6. Implement (`coder` subagent or direct edit).
7. GIT commit after edit.
8. Load `review` subagent (`templates/subagent-calls/review.md`) — adversarial PASS/FAIL (§7.7). Only tick when all 10 axes PASS.
9. Verify: syntax → targeted test → regression → diff review (with observed output).
10. Record in `CURRENT_STATE.md`; tick in `TASKS.md`.

Never claim a test passed without observed output.

## 2.1 Architectural Escalation — Architect Sub-Agent

`agent-core` invokes the `architect` sub-agent when a task introduces or exposes significant architectural complexity.

**Invocation triggers:**
- New projects or projects without architecture documentation.
- Unclear component responsibilities or module dependencies.
- Introduction of major components.
- Database schema redesigns or significant API changes.
- Refactoring across multiple modules.

**Do not invoke for:**
- Simple bug fixes or isolated function updates.
- Small utilities.
- Comment or formatting changes.

**Responsibilities:**
- Initial architecture design and discovery.
- Component responsibilities and dependency mapping.
- Architecture documentation and change management.
- Architectural governance and integrity.

**Boundaries:**
- Do not implement routine features.
- Do not modify production code without explicit delegation.
- Do not invent undocumented functionality.
- Do not override approved design decisions.
- Evaluate dependencies before introducing them.
- Avoid unnecessary documentation regeneration.

Architecture decisions must be reflected in `ARCHITECTURE.md` and significant design decisions recorded in `DECISIONS.md`.

Manual invocation is unnecessary when `agent-core` identifies a defined trigger.

## 3. Task Execution

Consolidated in §2 checklist above. Key rules only:
- Concurrent edit guard: never edit a file another agent is writing; verify file state before edit (`read` last 5 lines before `edit`).
- Stop-and-ask: label `PRELIMINARY` and stop on unverified assumptions.
- Failure budget: see §3.5.

When a failure survives a second correction attempt on a knowledge gap: load `self-help`, pass `LEARNING_BRIEF`. After skill approval (§6), retry against ORIGINAL criteria; do not weaken.

## 3.5 Failure Budget & Root-Cause Gate

Before ticking any sub-subtask complete:
1. Load `review` subagent (`--agent review`) with `templates/subagent-calls/review.md`.
2. The `review` agent performs adversarial review using the structured PASS/FAIL checklist (§7.7) — 10 axes with one-line verdicts per axis.
3. If any axis fails: do NOT tick. Document failure in `RESEARCH.md` (line refs, evidence, severity, which option was evaluated), fix or split further, retry.
4. Only tick when all 10 axes pass AND verification commands ran with observed output.
5. This applies to ALL sub-subtasks, not just the final milestone — overnight runs must not silently accumulate errors.

The planner never approves its own work unverified — an adversarial subagent verifies each step.

Every sub-subtask earns its own file, not an append-only global log: write attempts to `memory/learning/tasks/<task-id>-attempts.jsonl` (one line per try). When the sub-subtask resolves (success, final failure, or workaround adopted), append **one** summary line to `memory/learning/metrics.jsonl` — then delete `<task-id>-attempts.jsonl`. Never leave per-task tracking files after resolution; never grow `metrics.jsonl` beyond one line per sub-subtask.

`{"timestamp":"...","task_id":"m1-t1","subtask":"st1-edit-eval","attempt":1,"status":"fail","reason":"oldString mismatch on evaluation.py"}`

Rules:
- Write each attempt line to `memory/learning/tasks/<task-id>-attempts.jsonl` (not a global file).
- **Attempt 1 (fail)**: retry with a different approach — inspect file bytes exactly (`read`), verify whitespace/indentation, confirm exact oldString.
- **Attempt 2 (fail)**: load `review` or `research` subagent to diagnose root cause. Write diagnosis to `memory/learning/briefs/<task-id>-attempt2.md`. Classify: if root cause is a tool/execution failure (e.g., edit oldString mismatch, exact-match requirement, environment) → stay local; do not emit `LEARNING_BRIEF` or load global `self-help`. Only if the root cause is a recurring structural knowledge gap (`ALGORITHM_UNDERSTANDING_GAP`, `API_OR_LIBRARY_MISUSE`, `DATA_OR_SCHEMA_CONVENTION_GAP`, etc.) emit a `LEARNING_BRIEF` block for §5. Do NOT retry blindly.
- **Attempt 3 (fail)**: stop retrying this sub-subtask. Write proposed workaround to `memory/CURRENT_STATE.md`, load `autopilot.md` or split further in `TASKS.md`. Then summarize one line (`{task_id,subtask,attempts,status,root_cause,workaround}`) to `memory/learning/metrics.jsonl` and delete `memory/learning/tasks/<task-id>-attempts.jsonl`.
- **Breakdown format**: `TASKS.md` uses IDs (`mN-tN-stN-ssN`) so each sub-subtask can have its own `memory/learning/tasks/<id>-attempts.jsonl`; never share a budget across unrelated subtasks.

Example (your evaluation.py failure): attempt 1 failed due to context mismatch; attempt 2 should read the exact block from the file, confirm indentation; attempt 3 triggers `review` → RCA = "edit tool requires exact match" → workaround = construct exact string from `read` output, edit once; if that also fails, split into sub-subtask (`read` verification → `edit` application → `test`) rather than repeating the same edit attempt.

Never retry the same action unchanged after a failure.

## 3.6 Subagent Invocation Templates

When invoking a subagent, use the corresponding template from `templates/subagent-calls/`:
- `researcher.md` — for investigation/discovery tasks (invoke: `--agent research`)
- `review.md` — for code review tasks
- `coder.md` — for code generation tasks
- `autopilot.md` — for overnight/unattended runs

Fill in the bracketed sections. If no template exists for the task type, create one via the self-help process (§7.5) before invoking the subagent. Templates ensure a structured, complete prompt rather than an ad-hoc one.

## 3.7 Planner vs Execution Model Divergence

- All planning, root-cause classification, `LEARNING_BRIEF` emission, and approval decisions use the planner endpoint (declared in `opencode.json` as `model`).
- Subagent execution (`coder`, `research`, `review`, `autopilot`) must route through the local endpoint (declared in `opencode.json` as the local provider) for all writes, reads, edits, tests, and diffusion steps. The planner never passes subagent execution to the cloud endpoint.
- Rationale: planner token budget is limited (daily allowance); execution token budget is unbounded (local GPU). Enforce this split at every subagent invocation to protect the planner's cap and avoid burning free tokens on code-generation loops.
- If subagent execution needs a different model for a specific task, declare it in the subagent spec (`execution_model`) rather than overriding the planner's `model`.

## 3.8 Planner Verification of Subagent Output

When a subagent returns a report, the planner MUST verify key claims before using them:

1. **Mandatory answer check**: Did the subagent state the direct answer to the mission question? If not, reject and re-prompt.
2. **Evidence check**: For every factual claim (line numbers, counts, file paths), verify with at least one independent command or file read. Do not trust the subagent's claims blindly.
3. **No empty sections**: Every section in the required output structure must contain content. Reject reports with blank sections.
4. **Cross-check**: Confirm key findings with at least two independent sources before using them in planning.

This rule exists because small models produce reports that "have the shape of an answer" but may contain unverified or hallucinated specifics. The planner is the quality gate.

Persistent project knowledge lives in `memory/`.

- `PROJECT_INDEX.md`: repository map and navigation.
- `CURRENT_STATE.md`: active milestone, task, and next actions.
- `ARCHITECTURE.md`: verified system architecture and data flow.
- `DECISIONS.md`: important design decisions and rationale.
- `KNOWN_ISSUES.md`: unresolved defects, limitations, and risks.
- `milestones/`: milestone-specific implementation and verification records.
- `learning/briefs/`: Learning Briefs emitted by the `review` agent (§5).
- `learning/metrics.jsonl`: one JSON line per completed learning cycle.

Read only the files relevant to the current task.

Update project knowledge when the implementation, architecture, decisions, or
verified project state materially changes.

Do not record assumptions as facts.

## 3.9 Vague Prompt Handler (Two-Step Filter)

When the operator gives a vague or broad prompt:

**Step A (Scan)**: Load `repo-discovery`, list top 5 relevant areas/files. Output sub-questions only — no full report.
**Step B (Decompose)**: Break findings into max 3 specific, answerable questions. Each must map to one file read or command.

Only proceed after Step B. For each sub-question: invoke `--agent research` with `templates/subagent-calls/researcher.md`. Planner synthesizes all results (not sub-researchers).

## 5. Learning Loop (self-improving)

When the `review` subagent returns a `LEARNING_BRIEF` block after a failure
has survived a second correction attempt on a knowledge-gap failure:

1. Do NOT edit code to retry blindly.
2. Write the returned `LEARNING_BRIEF` block to
   `memory/learning/briefs/<task-id>.md`. Template: the global `self-help`
   skill at `~/.config/opencode/skills/self-help/templates/learning-brief.md`.
3. Load the `self-help` skill and pass it the Brief path. self-help researches
   the gap, drafts a Power-of-10 skill, and clears the Learning Gate
   (evidence, relevance, correctness, scope, executable check).
4. Approval: if §6 Skill Policy declares `auto-approve: project-skills`, the
   skill activates as `auto-approved-provisional`; otherwise self-help pauses
   for human approval.
5. Retry once against the ORIGINAL acceptance criteria.
6. Run the FULL regression suite (not just the failing test).
7. Append one JSON line to `memory/learning/metrics.jsonl`.

Never generate a skill for a trivial `IMPLEMENTATION_DEFECT`. Never weaken the
original acceptance criteria to make a retry pass.

## 6. Skill Policy

Controls whether new project skills need human approval before activating.

    auto-approve: project-skills
    max-new-skills-per-run: 3

- `auto-approve: project-skills` — skips the human pause for PROJECT-scoped
  skills only (global promotion always requires review). The Learning Gate
  still runs on every skill. Remove this line (or set to `off`) to require
  human approval for every new skill.
- `max-new-skills-per-run` — cap per autonomous run; when exceeded, stop and
  escalate rather than generating more.
- Every auto-approved skill is PROVISIONAL (`Status: auto-approved-provisional`)
  until reviewed. Audit them in `.opencode/skills/` and `metrics.jsonl`.

## 7. Skill Management

Project skills live in `.opencode/skills/`. Global skills provide reusable engineering practices (see global AGENTS.md).

Before creating a new skill:
1. Check whether an existing skill already covers the problem.
2. Determine whether the gap is recurring and project-specific.
3. If project-specific, draft the skill under `.opencode/skills/`.
4. If broadly reusable, propose it for the global skills repository.
5. Validate the new skill's instructions and frontmatter.
6. Apply §6 Skill Policy for approval (human gate, or auto-approve).

Do not create skills for one-off bugs or ordinary debugging.

Do not automatically promote project-specific knowledge to global skills.

## 7.5 Template Management

Structured output templates live in `skills/self-help/templates/` (global) and `.opencode/templates/` (project).

Before producing structured output (learning brief, skill draft, task breakdown, review report):
1. Check `templates/` for an existing template matching the output type.
2. If a template exists, use it — do not invent a new structure.
3. If no template exists, load `self-help` to research the output format, draft a minimal template, and place it in `templates/` for future use. This is a one-time effort — subsequent tasks reuse the template.
4. Templates are versioned with the project. Update them when the output format changes.

## 7.6 Self-Help Two-Phase Split (quality-preserving)

When a knowledge-gap failure triggers `self-help` (§5), split the pipeline into two phases:

**Phase A — Research + Draft (planner):**
1. Load `self-help` and read the Learning Brief.
2. Research: websearch → cross-check (≥2 sources) → adversarial critique → reproducible example.
3. Draft the skill using `.opencode/skills/self-help/templates/skill-template.md`.
4. Output: draft skill + sources + evidence labels.

**Phase B — Learning Gate (review):**
1. Validate all 5 checks (evidence, relevance, correctness, scope, executable check).
2. Approve or reject with one-line reason per check.
3. If approved → activate as `auto-approved-provisional` (per §6). If rejected → return to Phase A with specific feedback.

Quality is preserved: same research depth, same Learning Gate. The split just moves heavy reasoning to the planner and verification to the `review` agent.

## 7.7 Reviewer Checklist Format

Use a structured pass/fail checklist instead of open-ended prose. For each axis, commit to a verdict and one-line reason:

```
1. Correctness:     PASS/FAIL — <one-line reason>
2. Error handling:  PASS/FAIL — <one-line reason>
3. Edge cases:      PASS/FAIL — <one-line reason>
4. Concurrency:     PASS/FAIL — <one-line reason>
5. Resource cleanup: PASS/FAIL — <one-line reason>
6. Security:        PASS/FAIL — <one-line reason>
7. Backwards compat: PASS/FAIL — <one-line reason>
8. Tests:           PASS/FAIL — <one-line reason>
9. Complexity:      PASS/FAIL — <one-line reason>
10. Assumptions:    PASS/FAIL — <one-line reason>
```

This forces a verdict per axis rather than prose that may miss issues.

## 7.8 Deep Research / Sub-Task Decomposition

Research each task in depth before implementing:

1. Read `PROJECT_INDEX.md` first — never start coding without the index.
2. Break the task into sub-tasks in `TASKS.md` using IDs (`mN-tN-stN-ssN`).
3. Each sub-task gets its own `memory/learning/tasks/<id>-attempts.jsonl`.
4. If a sub-task is still too complex (e.g., requires >3 files or >1 hour), break it further into sub-sub-tasks.
5. Never implement a task that hasn't been decomposed. If you can't decompose it, load `repo-discovery` first.

This is already partially implemented via `TASKS.md` IDs and §3.5 failure budget. The rule above makes it explicit.

## 7.9 Compact Learning Brief (Mandatory Format)

When `review` returns `LEARNING_BRIEF` (failure survived 2 attempts):

```
LEARNING_BRIEF (compact — 4 fields)
task_id: <id>
root_cause: <classification>
evidence: <one-line>
learning_objective: <one sentence>
```

Rules:
- Planner writes this file to `memory/learning/briefs/<task-id>.md`.
- Never generate a skill for a trivial `IMPLEMENTATION_DEFECT`.
- Never weaken original acceptance criteria for retry.

Full 8-field expansion only when `self-help` requires it (§5).

## 8. Evidence and Correctness

**Verification Standard** (applies to all observations and subagent claims):
- Every claim labeled `VERIFIED` must cite an independent source (command output, file read, grep result).
- Every claim labeled `PRELIMINARY` must state the limitation that prevents verification.
- Never label a claim `VERIFIED` without an attached reference.

Global Engineering Standards (verification, principles, behaviour) apply. This section adds project-specific evidence rules:

- Distinguish between verified facts, reasonable hypotheses, unverified assumptions, and known limitations.
- Prefer repository evidence and reproducible experiments over memory.
- When code behaviour is unclear, inspect the implementation and construct a test that distinguishes competing explanations.
- If applicable to this project (e.g. ML/data work), investigate temporal leakage, data leakage, incorrect labels, invalid evaluation splits, and inappropriate baselines.

## 9. Completion

A task is complete only when:

- Its acceptance criteria have been checked.
- Relevant tests have been executed.
- Results are accurately reported.
- The diff has been reviewed.
- Required project documentation is updated.
- Remaining risks and limitations are recorded.
- `TASKS.md` reflects the actual task status.
