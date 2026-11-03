# <PROJECT_NAME> — Agent Instructions

> This file layers **project-specific** rules on top of the GLOBAL agent config
> (`~/.config/opencode/AGENTS.md` + global skills). Global rules still apply and
> are NOT replaced here: Engineering Standards, the skill hierarchy
> (`agent-core` → `readable-code` + `repo-discovery` → language/domain →
> `quality-gate`), security/WebFetch policy, and the global Learning Loop
> pointer. This file adds the project's workflow, knowledge layout, and the
> self-improving Skill Policy.

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

## 2. Mandatory Task Startup

At the start of every new task:

1. Check `memory/PROJECT_INDEX.md`. If missing or stale: load `repo-discovery`, inspect repository structure, and create/update `memory/PROJECT_INDEX.md` before any task work.
2. Read `memory/CURRENT_STATE.md`.
3. Read `TASKS.md` to identify the active task and dependencies.
4. Identify the relevant project area and inspect its current implementation.
5. Load the most relevant available skill using the native skill tool (max 3 skills per task; if more are needed, split the task into sub-tasks). Select skills by matching the file's language, domain, and task type — never load a skill "just in case".
6. Load additional skills only when their guidance is needed.

For an unfamiliar subsystem, load `repo-discovery` before modifying code.

Do not read the entire repository by default. Follow the project index to the
relevant files.

If an index entry is missing or stale, verify the repository and correct it.

## 3. Task Execution

For non-trivial tasks:

1. Load `repo-discovery` (unfamiliar subsystem) or inspect implementation.
2. Establish expected behaviour and acceptance criteria.
3. Identify affected modules and tests.
4. Load the language/domain skill (e.g., `python-code`, `go-code`) and plan the smallest coherent change.
5. If task is difficult/complex, load `researcher` subagent to fill knowledge gap
6. Load `coder` subagent (or implement directly using the loaded skill) — write the change.
7. Use GIT at step 6 (commit after plan/change).
8. Run targeted tests.
9. Run relevant regression tests.
10. Load `reviewer` subagent to inspect diff / review correctness, security, architecture.
11. Record actual results and unresolved issues in `memory/CURRENT_STATE.md`.

Use GIT at steps 6 (commit after change) and 10 (review diff before concluding).

When a failure survives a second correction attempt on a knowledge gap:
- Load `self-help`, pass the `LEARNING_BRIEF`.
- After skill approval (§6), retry against ORIGINAL criteria; do not weaken.

Never claim a test passed unless executed and observed.

- **Stop-and-ask threshold (small models)**: If you cannot verify an assumption with a single file read or command, label it `PRELIMINARY` and stop. Do not proceed on unverified assumptions. Ask or document the blocker rather than guessing.

## 3.5 Failure Budget & Root-Cause Gate

Every sub-subtask earns its own file, not an append-only global log: write attempts to `memory/learning/tasks/<task-id>-attempts.jsonl` (one line per try). When the sub-subtask resolves (success, final failure, or workaround adopted), append **one** summary line to `memory/learning/metrics.jsonl` — then delete `<task-id>-attempts.jsonl`. Never leave per-task tracking files after resolution; never grow `metrics.jsonl` beyond one line per sub-subtask.

`{"timestamp":"...","task_id":"m1-t1","subtask":"st1-edit-eval","attempt":1,"status":"fail","reason":"oldString mismatch on evaluation.py"}`

Rules:
- Write each attempt line to `memory/learning/tasks/<task-id>-attempts.jsonl` (not a global file).
- **Attempt 1 (fail)**: retry with a different approach — inspect file bytes exactly (`read`), verify whitespace/indentation, confirm exact oldString.
- **Attempt 2 (fail)**: load `reviewer` or `research` subagent to diagnose root cause. Write diagnosis to `memory/learning/briefs/<task-id>-attempt2.md`. Classify: if root cause is a tool/execution failure (e.g., edit oldString mismatch, exact-match requirement, environment) → stay local; do not emit `LEARNING_BRIEF` or load global `self-help`. Only if the root cause is a recurring structural knowledge gap (`ALGORITHM_UNDERSTANDING_GAP`, `API_OR_LIBRARY_MISUSE`, `DATA_OR_SCHEMA_CONVENTION_GAP`, etc.) emit a `LEARNING_BRIEF` block for §5. Do NOT retry blindly.
- **Attempt 3 (fail)**: stop retrying this sub-subtask. Write proposed workaround to `memory/CURRENT_STATE.md`, load `autopilot.md` or split further in `TASKS.md`. Then summarize one line (`{task_id,subtask,attempts,status,root_cause,workaround}`) to `memory/learning/metrics.jsonl` and delete `memory/learning/tasks/<task-id>-attempts.jsonl`.
- **Breakdown format**: `TASKS.md` uses IDs (`mN-tN-stN-ssN`) so each sub-subtask can have its own `memory/learning/tasks/<id>-attempts.jsonl`; never share a budget across unrelated subtasks.

Example (your evaluation.py failure): attempt 1 failed due to context mismatch; attempt 2 should read the exact block from the file, confirm indentation; attempt 3 triggers reviewer → RCA = "edit tool requires exact match" → workaround = construct exact string from `read` output, edit once; if that also fails, split into sub-subtask (`read` verification → `edit` application → `test`) rather than repeating the same edit attempt.

Never retry the same action unchanged after a failure.

## 4. Project Knowledge

Persistent project knowledge lives in `memory/`.

- `PROJECT_INDEX.md`: repository map and navigation.
- `CURRENT_STATE.md`: active milestone, task, and next actions.
- `ARCHITECTURE.md`: verified system architecture and data flow.
- `DECISIONS.md`: important design decisions and rationale.
- `KNOWN_ISSUES.md`: unresolved defects, limitations, and risks.
- `milestones/`: milestone-specific implementation and verification records.
- `learning/briefs/`: Learning Briefs emitted by the reviewer (§5).
- `learning/metrics.jsonl`: one JSON line per completed learning cycle.

Read only the files relevant to the current task.

Update project knowledge when the implementation, architecture, decisions, or
verified project state materially changes.

Do not record assumptions as facts.

## 5. Learning Loop (self-improving)

When the `reviewer` subagent returns a `LEARNING_BRIEF` block after a failure
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

Global skills provide reusable engineering practices.

Project skills live in `.opencode/skills/`.

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

When a knowledge-gap failure triggers `self-help` (§5), split the pipeline into two phases to reduce load on small models:

**Phase A — Research + Draft (planner, cloud model):**
1. Load `self-help` and read the Learning Brief.
2. Research: websearch → cross-check (≥2 sources) → adversarial critique → reproducible example.
3. Draft the skill using `templates/skill-template.md`.
4. Output: draft skill + sources + evidence labels.

**Phase B — Learning Gate (reviewer, small model):**
1. Validate all 5 checks (evidence, relevance, correctness, scope, executable check).
2. Approve or reject with one-line reason per check.
3. If approved → activate as `auto-approved-provisional` (per §6). If rejected → return to Phase A with specific feedback.

Quality is preserved: same research depth, same Learning Gate. The split just moves heavy reasoning to the planner and verification to the small model.

## 7.7 Reviewer Checklist Format (small-model optimized)

When `reviewer` runs on a small model, use a structured pass/fail checklist instead of open-ended prose. For each axis, commit to a verdict and one-line reason:

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

This forces the small model to commit to a verdict per axis rather than writing prose that may miss issues. Cloud models may use the full prose format.

## 7.8 Capability-Tiering (without cumbersomeness)

Add a `model_tier` field to agent specs (`small` / `medium` / `large`). Default = `small`.

- If `model_tier == small`, the agent loads a **simplified prompt variant** (shorter instructions, more guardrails, stop-and-ask threshold). Large models ignore this section.
- If `model_tier == large`, the agent loads the full prompt with all optional sections.
- No extra config needed — just a conditional block in the agent spec:

```
## Small-model mode (when model_tier == small)
- Use shorter instructions
- Break tasks into smaller sub-tasks
- Stop and ask on unverified assumptions
- Load at most 2 skills per task
```

## 7.9 Compact Learning Brief (small-model variant)

Keep the full 8-field template for cloud models. For small models, use a compact 4-field variant:

```
LEARNING_BRIEF (compact)
task_id: <id>
root_cause: <classification>
evidence: <one-line>
learning_objective: <one sentence>
```

The small model produces this; the planner expands it to the full template if needed. This reduces output token burden while preserving the core signal.

## 7.10 Deep Research / Sub-Task Decomposition (small models)

Small models must research each task in depth before implementing:

1. Read `PROJECT_INDEX.md` first — never start coding without the index.
2. Break the task into sub-tasks in `TASKS.md` using IDs (`mN-tN-stN-ssN`).
3. Each sub-task gets its own `memory/learning/tasks/<id>-attempts.jsonl`.
4. If a sub-task is still too complex (e.g., requires >3 files or >1 hour), break it further into sub-sub-tasks.
5. Never implement a task that hasn't been decomposed. If you can't decompose it, load `repo-discovery` first.

This is already partially implemented via `TASKS.md` IDs and §3.5 failure budget. The rule above makes it explicit for small models.

## 8. Evidence and Correctness

Distinguish between:

- Verified facts.
- Reasonable hypotheses.
- Unverified assumptions.
- Known limitations.

Prefer repository evidence and reproducible experiments over memory.

When code behaviour is unclear, inspect the implementation and construct a
test that distinguishes competing explanations.

If applicable to this project (e.g. ML/data work), investigate temporal
leakage, data leakage, incorrect labels, invalid evaluation splits, and
inappropriate baselines.

## 9. Completion

A task is complete only when:

- Its acceptance criteria have been checked.
- Relevant tests have been executed.
- Results are accurately reported.
- The diff has been reviewed.
- Required project documentation is updated.
- Remaining risks and limitations are recorded.
- `TASKS.md` reflects the actual task status.

### Planner vs Execution Model Divergence
- All planning, root-cause classification, `LEARNING_BRIEF` emission, and approval decisions use this endpoint only.
- Subagent execution (`coder`, `research`, `reviewer`, `autopilot`) must route through the local endpoint (`lmstudio/google/gemma-4-e4b`) for all writes, reads, edits, tests, and diffusion steps. The planner never passes subagent execution to the cloud endpoint.
- Rationale: planner token budget is limited (daily allowance); execution token budget is unbounded (local GPU). Enforce this split at every subagent invocation to protect the planner's cap and avoid burning free tokens on code-generation loops.
- If subagent execution needs a different model for a specific task, declare it in the subagent spec (`execution_model`) rather than overriding the planner's `model`.
