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
Example: "Build and maintain X. Priorities: 
1) correctness
2) data integrity
3) testability
4) performance
A passing test suite does not by itself
establish correctness.">

## 2. Mandatory Task Startup

At the start of every new task:

1. Read `memory/PROJECT_INDEX.md`.
2. Read `memory/CURRENT_STATE.md`.
3. Read `TASKS.md` to identify the active task and dependencies.
4. Identify the relevant project area and inspect its current implementation.
5. Load the most relevant available skill using the native skill tool.
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
11. Record actual results and unresolved issues in \memory/CURRENT_STATE.md\.
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
Example: "Build and maintain X. Priorities: 1) correctness, 2) data integrity,
3) testability, 4) performance. A passing test suite does not by itself
establish correctness.">

## 2. Mandatory Task Startup

At the start of every new task:

1. Read `memory/PROJECT_INDEX.md`.
2. Read `memory/CURRENT_STATE.md`.
3. Read `TASKS.md` to identify the active task and dependencies.
4. Identify the relevant project area and inspect its current implementation.
5. Load the most relevant available skill using the native skill tool.
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

## 3.5 Failure Budget & Root-Cause Gate

Every subtask (projects → tasks → subtasks → sub-subtasks) has its own retry budget of **3 attempts** before a subagent must investigate. Track in `memory/learning/retry-counters.jsonl` (one JSON line per attempt):

`{"timestamp":"...","task_id":"m1-t1","subtask":"st1-edit-eval","attempt":1,"status":"fail","reason":"oldString mismatch on evaluation.py"}`

Rules:
- **Attempt 1 (fail)**: retry with a different approach — inspect file bytes exactly (`read`), verify whitespace/indentation, confirm exact oldString.
- **Attempt 2 (fail)**: load `reviewer` or `research` subagent to diagnose root cause (e.g., edit-tool exact-match requirement, missing import, wrong file). Write diagnosis to `memory/learning/briefs/<task-id>-attempt2.md`. Do NOT retry blindly.
- **Attempt 3 (fail)**: stop retrying this subtask. Load `autopilot.md` or `reviewer.md` to propose a workaround: split sub-subtask further (`TASKS.md`), apply a different method, or escalate to `LEARNING_BRIEF`. Update `CURRENT_STATE.md` with the proposed workaround.
- **Breakdown format**: `TASKS.md` uses IDs (`m1-t1-st1`) so each sub-subtask can have its own counter line; never share a budget across unrelated subtasks.

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
