# Rigour Invocation Template (Rigorous Orchestrator)

Use when activating the `/rigour` command or switching to the `rigour` agent. It runs the full multi-stage quality pipeline for every task: research → decomposition → adversarial review → planning → implement → review → test → sign-off. Fill in bracketed sections.

## MISSION
[The operator's goal: work existing TASKS.md list to completion with full rigour, or merge request into TASKS.md as new milestone with full pipeline.]

## ENTRY MODE — decide first
- **Mode A (resume)** — request refers to existing list ("continue", "resume", "finish"). Start at first unchecked item.
- **Mode B (new goal)** — merge into TASKS.md as new milestone (3–12 items); append only.

## RIGOUR PIPELINE (mandatory for every task)

### 0. Bootstrap & Task Selection
Read AGENTS.md, memory/CURRENT_STATE.md, TASKS.md. Select next eligible unchecked root task.

### 1. Task + Project Research
- Research the specific task implementation details.
- Research architectural fit: read PROJECT_INDEX, architecture docs, mission, related tasks.
- Document findings + evidence in tasks/<id>.md (## Research section).
- Identify blockers and alternatives.

### 2. Decomposition
- Break task into researched subtasks based on research findings.
- Create detail files for each subtask if needed (tasks/subtask-id.md).
- Document decomposition rationale in task file.

### 3. Adversarial Review of Research
- Independent critique of research findings and proposed approach.
- Identify gaps, risks, assumptions.
- Document review verdict (PASS/FAIL) with evidence.

### 4. Implementation Planning
- Detailed plan: files to change (≤5; split bigger work into subtasks), required updates to PROJECT_INDEX.md/README/architecture notes, security considerations, test requirements.
- Document in tasks/<id>.md planning section.

### 5. Coder (Implementation)
- Implement according to approved plan and research.
- Single coder call per change unless complexity demands escalation.
- Add/update tests if required by acceptance criteria.
- Report files changed + commands run.

### 6. Review (Adversarial)
- Adversarial review of actual diff (10-axis + Power-of-10 + security).
- Verdict: PASS/FAIL per criterion with file:line evidence, reproduction if FAIL, recommended fix.

### 7. Test (Full Verification)
- Full verification sequence: static analysis → build → targeted tests → regression → integration → security checks → broader suite.
- Capture exact commands, exit codes, output, pass/fail counts.
- On failure: root cause first; follow failure budget (investigate → deeper research → reconsider approach).

### 8. Sign-off / Quality Gate
- Final acceptance criteria check + documentation updates.
- If any fails, task remains incomplete — do not tick.

### 9. Proceed to Next Task (or Subtask)
- Update state, select next eligible unchecked root task OR subtask.
- Repeat from Step 1 for next item.

## NOTES
- This template enforces full pipeline for every task — no shortcuts.
- Specialist agents (coder, research, review, test) are invoked explicitly at each stage.
- State files (TASKS.md, tasks/, CURRENT_STATE.md) are shared with autopilot mode.
- Can be invoked as `@rigour` subagent for full pipeline enforcement.
