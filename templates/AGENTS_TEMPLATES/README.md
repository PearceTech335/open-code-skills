# AGENTS_TEMPLATES — Project Starter (Two-Layer Scaffold)

Copy/paste this folder's contents into a new OpenCode project root: `AGENTS.md`, `MISSION.md`, `TASKS.md`, `tasks/`, `templates/`, `memory/`, `.opencode/skills/` — but **not** `README.md` (which documents the template, not your project).

The project is governed by **two files, loaded together**:
- Global base: `~/.config/opencode/AGENTS.md` — hard rules (workflow, verification, principles, STE-inspired docs, Checkpoint Discipline, QA order). You do not fork those.
- Project complement: this file's `AGENTS.md` — mission, TASKS workflow, failure budget, Learning Loop, Skill Policy, memory layout. **Customize only its header and `## 1. Mission`** (and the STE opt-in declaration, if the project needs full ASD-STE100 conformance). Leave the rest aligned with the global config.

> *STE-inspired plain language throughout this repo — no "ASD-STE100 compliant" claims anywhere.*

## What this folder is for

- **Project mission brief** (`MISSION.md`) — what the project is, its source of truth, execution host, sync discipline, credentials, and priorities. Kept separate from `AGENTS.md` so the workflow file can be re-aligned with the global template without losing project context (`AGENTS.md` §1 points here).
- **Project-level agent instructions** (`AGENTS.md`) — startup rules (§2 checklist), execution protocol (§3), evidence/correctness standards (§8 Verification Standard: VERIFIED claims cite independent source; PRELIMINARY states limitation), and the Learning Loop (§5) + Skill Policy (§6). Behaviour (§3.5): uncertain conditions trigger structured `research.md`/`review.md` subagent calls, not open-ended prose. `supervisor` gates ticks on multi-subtask runs (§3.5 step 7; heartbeat to `PROGRESS.md`).
- **Task index + detail files** (`TASKS.md` + `tasks/<id>.md`) — `TASKS.md` is a thin one-line-per-task index (may grow to hundreds of lines); each line links to `tasks/<id>.md`, the detail file the research/coder/review agents fill with research, scope, references, testing criteria, attempts and pass/fail evidence. One file per task = one reviewable record.
- **Self-improving skills** (`.opencode/skills/`) — where project-specific skills live; the `self-help` skill drafts them, the Learning Gate validates them, and the Skill Policy controls approval.
- **Project knowledge scaffold** (`memory/`) — persistent index, state, architecture, decisions, known issues, milestones, and the `learning/` sink (`briefs/` + `metrics.jsonl`).
- **Copy/paste starter** — new repo? Drop this folder's contents at root and fill in `MISSION.md` and `memory/PROJECT_INDEX.md` from the real repo.

Global rules (`agent-core`, `readable-code`, `repo-discovery`, `quality-gate`, `security`, WebFetch policy, the global Learning Loop pointer in `AGENTS.md`) still apply. This file gives the project its spin on workflow, knowledge layout, and autonomous improvement.

## Two operating modes explained

This project scaffold supports two distinct orchestration modes via the same state files (`TASKS.md`, `tasks/`, `CURRENT_STATE.md`):

### Autopilot (default) — Light loop
The `autopilot` agent uses a slimmed-down loop for capable models. It assumes the model can internalise much of the research/review/test discipline. External specialist agents are invoked only when escalation criteria are met (ambiguity, high-risk changes, or operator request). A small local model can use autopilot to create the task list, then use `@rigour` to complete it with verified, tested code.

### @rigour — Full multi-stage quality pipeline
Invoke `@rigour` when a small local model must complete `TASKS.md` with verified, tested code and no manual debugging. The operator can create the task list with autopilot, then prompt "do the tasks with @rigour". Every task goes through research → decomposition → adversarial review → planning → implementation → review → test → sign-off. `@rigour` delegates to the specialist agents (`research`, `coder`, `review`, `test`); this requires `@rigour` to carry `subagent` permissions in its frontmatter. `@rigour` is the only rigour entry point.

### Model routing
`opencode.json` declares one model; agents inherit it unless routed per project.
Edit §3.7 of this project's `AGENTS.md`: add one line per agent
(`<agent>: <provider>/<model>`); remove a line to let that agent inherit the session
model. The planner passes the listed `model:` on the `subagent` tool call. Verify
tool support before adding a route: LM Studio `capabilities` must include
`tool_use`, and a tool probe must return structured `tool_calls`, not plain text.

## Process enforcement for small local models

This starter targets sustained agentic coding on small, self-hosted models at modest configured contexts — whatever tool-calling model you declare in `opencode.json` — by enforcing a frontier-model-style process per task: file-first state (`PROJECT_INDEX`/`CURRENT_STATE`/`TASKS` index + `tasks/<id>.md` detail files), research before implementation, adversarial `review`, execution-based `test`, and `supervisor` gating before any tick (§2 steps 5/8c, §3.5 steps 6–7). Checklists, templates, per-task detail files and the failure budget externalise process discipline so it does not depend on model scale — at the cost of per-task subagent latency, which the file-first design contains. `AGENTS.md` stays lean: it only points at the skill/agent/template files that carry the detail.

## How the autonomous Learning Loop works

Wired by `AGENTS.md` §5 and the `review` subagent (`agents/review.md`), with `self-help` (`~/.config/opencode/skills/self-help/SKILL.md`) doing the research/drafting:

```
Task fails on a knowledge-gap failure (second correction attempt fails)
        ↓
`review` emits LEARNING_BRIEF block
        ↓
write LEARNING_BRIEF → memory/learning/briefs/<task-id>.md
        ↓
load self-help, pass the Brief path
        ↓
self-help researches (source acquisition → cross-check against independent sources → critique → counterexample → repro)
        ↓
drafts Power-of-10 skill (YAML frontmatter, numbered rules, guardrails, verification protocol)
        ↓
Learning Gate (evidence, relevance, correctness, scope, executable checks)
        ↓
Approval: Section 6 Skill Policy
   • auto-approve: project-skills  → activates as auto-approved-provisional
   • (line removed / set off)     → pauses for human review
        ↓
Retry against ORIGINAL acceptance criteria (not weakened)
        ↓
Run FULL regression suite (not just failing test)
        ↓
`test` PASS required (§3.5 step 6)
         ↓
`supervisor` CONTINUE required to tick (§3.5 step 7)
         ↓
Append JSON line to memory/learning/metrics.jsonl
        ↓
Audit provisional skills in .opencode/skills/ + metrics.jsonl
```

**Two-Phase Split (§7.6):** When triggered, Phase A (research + draft) runs on the planner; Phase B (Learning Gate validation) runs on the `review` agent. Quality is preserved — same research depth, same Learning Gate.

**Key rules from `AGENTS.md`:**
- Never generate a skill for a trivial `IMPLEMENTATION_DEFECT`.
- Never weaken original acceptance criteria to make retry pass.
- Auto-approved skills are `Status: auto-approved-provisional`; always audit.
- `max-new-skills-per-run` caps autonomously generated skills per run; exceeding it stops the run instead of approving more.
- Tool/execution failures (repeated edit mismatches, exact-match errors) stay local (RCA by `review`, workaround, no global `self-help`) unless `review` classifies a recurring structural gap, which then triggers §5.
- Routing prefers existing skills (update before create); drafted skills are kept short.
- Spill raw tool output to `RESEARCH.md` and cite the path; keep cited evidence in-context (§8).
- `auto-approve` is project-scoped and provisional — post-run audit required (§6).

## Where agent/skill files live

| Scope | Path | How it's used |
|---|---|---|
| **Global skills** (engineering practices, templates) | `~/.config/opencode/skills/` | Load on demand by agent; include `self-help`, `agent-core`, `readable-code`, `repo-discovery`, `quality-gate`, `long-running-task-research`, `git-practices`, `supervisor`, `readme-authoring`, `research-method`, `ste-writing`, `auto-memory`, etc. |
| **Project skills** (project-specific patterns, new capabilities) | `.opencode/skills/` (inside this folder / project root) | Drafted by `self-help`; validated by Learning Gate; approved via §6; kept separate from global to avoid pollution |
| **Project agents / subagent specs** | `agents/*.md`, `commands/*.md` | Define roles (`review`, `coder`, etc.) with `description`, `mode`, `prompt`, optional `model:` override (omit to inherit global `model`) |
| **Self-help templates** | `~/.config/opencode/skills/self-help/templates/` | `skill-template.md`, `learning-brief.md` — starter formats for new skills/briefs |

## Skill Policy (§6 of AGENTS.md) — quick setup

In `AGENTS.md` Section 6, the starter ships fail-closed:

```
    auto-approve: off
```

`max-new-skills-per-run` also lives in Section 6: it caps how many skills may be generated per autonomous run; exceeding it stops the run. Its current value lives in `AGENTS.md` §6, which is the single source of truth — do not copy it into documentation.

- With `auto-approve: off`: every new skill pauses for human review (safer default; required when you want oversight).
- Set `auto-approve: project-skills`: unattended project-scoped skill approval, skills activate as provisional (global promotion always requires review). The Learning Gate still runs either way.
- Cap applies per autonomous run: exceeding it stops the run instead of approving more skills.

Audit trail lives in `.opencode/skills/` + `memory/learning/metrics.jsonl` (one JSON line per completed cycle: brief path, skill name, approval mode, retry result).

## Template directory purpose (`/templates/AGENTS_TEMPLATES/`)

This directory (`~/.config/opencode/templates/AGENTS_TEMPLATES/`) holds the **master starter scaffold** — the same contents you copy into a new project root. It's kept separate from global `AGENTS.md` so that:

- Global config (`~/.config/opencode/AGENTS.md`) stays stable across all projects.
- Each project gets its own `AGENTS.md`, `MISSION.md`, `TASKS.md`, `tasks/` (with `TEMPLATE.md`), `memory/`, `.opencode/skills/` without overriding globals.
- The template is version-controlled (git) and reusable; changes to the starter propagate by copying fresh.

When creating a new project: copy the contents of `/templates/AGENTS_TEMPLATES/` (not the folder envelope) into the new repo root, then fill in `MISSION.md` and `memory/PROJECT_INDEX.md` from the real repo.

## Subagent Invocation Templates (`templates/subagent-calls/`)

Standardized prompt templates for invoking subagents. Use the corresponding template when invoking a subagent — fill in the bracketed sections:

| Template | Purpose |
|----------|---------|
| `research.md` | Unified research template (investigation, decision research, task detail-file elaboration) |
| `review.md` | Code review tasks |
| `test.md` | QA testing tasks (runs test suite, PASS/FAIL with evidence) |
| `coder.md` | Code generation tasks |
| `autopilot.md` | Light loop for capable models: bootstrap, light discovery, direct implementation or one coder call, optional review/test, acceptance, tick |
| `rigour.md` | High-integrity pipeline for `@rigour`: research → decomposition → adversarial review → planning → coder → review → test → sign-off; delegates to specialists |

If no template exists for the task type, create one via the self-help process (§7.5) before invoking. Templates ensure the model receives a structured, complete prompt rather than an ad-hoc one.

## Failure Budget (§3.5 of AGENTS.md)

Every sub-subtask (`TASKS.md` ID) gets its own `memory/learning/tasks/<id>-attempts.jsonl`; after resolution (success/final failure/workaround) summarize one line to `memory/learning/metrics.jsonl` and delete the per-task file — no unbounded growth. Tool/execution failures stay local (RCA by `review`, workaround, no global `self-help`) unless `review` classifies a recurring structural gap.

## Research Decomposition (§3.9 of AGENTS.md)

When given a vague or broad research prompt, do not attempt to answer in one pass: (1) broad-brush scan to identify major areas and sub-questions, (2) decompose into focused, independently answerable sub-questions, (3) invoke the research agent for each sub-question with a focused prompt, (4) synthesize findings into the final report. The research agent elaborates the matching `tasks/<id>.md` detail file.

## Subagent Output Verification (§3.8 of AGENTS.md)

When a subagent returns a report, the planner must verify key claims before using them: (1) mandatory answer to the mission question stated, (2) every factual claim has attached evidence (command/file reference), (3) no empty sections, (4) cross-check against independent sources.

## Verification checklist (before reporting complete)

- [ ] `MISSION.md` filled (mission brief, source of truth, execution host, priorities); `AGENTS.md` §5 (Learning Loop) and §6 (Skill Policy) intact.
- [ ] §2 steps 5/7/8a/8b/8c and §3.5 steps 6-7 (test PASS + supervisor gate) intact; §3.5 (Failure Budget), §3.6 (Subagent Templates, incl. `test.md`), §3.7 (Model Routing, incl. `test`), §3.8 (Output Verification), §3.9 (Research Decomposition) intact.
- [ ] §7.5-§7.9 intact (Template Management, Self-Help Two-Phase, Reviewer Checklist, Deep Research, Compact Learning Brief).
- [ ] `TASKS.md` reflects actual milestone/task status with sub-subtask IDs (`mN-tN-stN-ssN`); each item links to a `tasks/<id>.md` detail file.
- [ ] `tasks/TEMPLATE.md` exists (copied from template); detail files are the per-task reviewable records.
- [ ] `memory/PROJECT_INDEX.md` verified against repo; paths exist, not invented.
- [ ] `.opencode/skills/` exists with `.gitkeep`; first skill draft placed when loop triggers.
- [ ] `memory/learning/briefs/` + `metrics.jsonl` + `tasks/` present (zero-byte sink ready).
- [ ] `templates/subagent-calls/` contains invocation templates (research.md, review, test, coder, autopilot, rigour).
- [ ] Evidence for any skill creation: source URLs, cross-checks, counterexample, reproduction, Learning Gate checks.


