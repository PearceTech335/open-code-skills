# AGENTS_TEMPLATES — Project Starter + Autonomous Learning Loop

This folder is the **copy/paste starter template** for new OpenCode projects. Copypaste its contents (`AGENTS.md`, `TASKS.md`, `memory/`, `.opencode/skills/`) to a new project root. It does **not** replace your global config (`~/.config/opencode/AGENTS.md` + global skills); it layers project-specific rules, the self-improving Learning Loop, and the Skill Policy on top.

## What this folder is for

- **Project-level agent instructions** (`AGENTS.md`) — mission, startup rules (§2 checklist), execution protocol (§3), evidence/correctness standards (§8 Verification Standard: VERIFIED claims cite independent source; PRELIMINARY states limitation), and the Learning Loop (§5) + Skill Policy (§6). Behaviour (§3.5/§2.6): uncertain conditions trigger structured `research.md`/`review.md` subagent calls, not open-ended prose.
- **Self-improving skills** (`.opencode/skills/`) — where project-specific skills live; the `self-help` skill drafts them, the Learning Gate validates them, and the Skill Policy controls approval.
- **Project knowledge scaffold** (`memory/`) — persistent index, state, architecture, decisions, known issues, milestones, and the `learning/` sink (`briefs/` + `metrics.jsonl`).
- **Copy/paste starter** — new repo? Drop this folder's contents at root and fill in Section 1 (Mission) and `memory/PROJECT_INDEX.md`.

Global rules (`agent-core`, `readable-code`, `repo-discovery`, `quality-gate`, `security`, WebFetch policy, the global Learning Loop pointer in `AGENTS.md`) still apply. This file gives the project its spin on workflow, knowledge layout, and autonomous improvement.

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
self-help researches (source acquisition → cross-check ≥2 → critique → counterexample → repro)
        ↓
drafts Power-of-10 skill (YAML frontmatter, numbered rules, guardrails, verification protocol)
        ↓
Learning Gate (5 checks: evidence, relevance, correctness, scope, executable check)
        ↓
Approval: Section 6 Skill Policy
   • auto-approve: project-skills  → activates as auto-approved-provisional
   • (line removed / set off)     → pauses for human review
        ↓
Retry against ORIGINAL acceptance criteria (not weakened)
        ↓
Run FULL regression suite (not just failing test)
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
- `max-new-skills-per-run: 3` (cap per autonomous run; exceed → stop/escalate).
- Tool/execution failures (repeated edit mismatches, exact-match errors) stay local (RCA by `review`, workaround, no global `self-help`) unless `review` classifies a recurring structural gap, which then triggers §5.

## Where agent/skill files live

| Scope | Path | How it's used |
|---|---|---|
| **Global skills** (engineering practices, templates) | `~/.config/opencode/skills/` | Load on demand by agent; include `self-help`, `agent-core`, `readable-code`, `repo-discovery`, `quality-gate`, `long-running-task-research`, `git-practices`, etc. |
| **Project skills** (project-specific patterns, new capabilities) | `.opencode/skills/` (inside this folder / project root) | Drafted by `self-help`; validated by Learning Gate; approved via §6; kept separate from global to avoid pollution |
| **Project agents / subagent specs** | `agents/*.md`, `commands/*.md` | Define roles (`review`, `coder`, etc.) with `description`, `mode`, `prompt`, optional `model:` override (omit to inherit global `model`/`small_model`) |
| **Self-help templates** | `~/.config/opencode/skills/self-help/templates/` | `skill-template.md`, `learning-brief.md` — starter formats for new skills/briefs |

**If you delete `small_model` from `opencode.json`,** subagents inherit `model` exactly 

## Skill Policy (§6 of this file) — quick setup

In `AGENTS.md` Section 6, set for this project:

```
    auto-approve: project-skills
    max-new-skills-per-run: 3
```

- With `auto-approve`: overnight autonomous runs proceed without human pauses; new skills activate as provisional.
- Without it (line removed / `off`): every skill pauses for review (safer when you want oversight).

Audit trail lives in `.opencode/skills/` + `memory/learning/metrics.jsonl` (one JSON line per completed cycle: brief path, skill name, approval mode, retry result).

## Template directory purpose (`/templates/AGENTS_TEMPLATES/`)

This directory (`C:\Users\pearc\.config\opencode\templates/AGENTS_TEMPLATES/`) holds the **master starter scaffold** — the same contents you copy into a new project root. It's kept separate from global `AGENTS.md` so that:

- Global config (`~/.config/opencode/AGENTS.md`) stays stable across all projects.
- Each project gets its own `AGENTS.md`, `TASKS.md`, `memory/`, `.opencode/skills/` without overriding globals.
- The template is version-controlled (git) and reusable; changes to the starter propagate by copying fresh.

When creating a new project: copy the contents of `/templates/AGENTS_TEMPLATES/` (not the folder envelope) into the new repo root, then edit Section 1 (Mission) and `memory/PROJECT_INDEX.md` from the real repo.

## Subagent Invocation Templates (`templates/subagent-calls/`)

Standardized prompt templates for invoking subagents. Use the corresponding template when invoking a subagent — fill in the bracketed sections:

| Template | Purpose |
|----------|---------|
| `researcher.md` | Investigation/discovery tasks |
| `review.md` | Code review tasks |
| `coder.md` | Code generation tasks |
| `autopilot.md` | Overnight/unattended runs |

If no template exists for the task type, create one via the self-help process (§7.5) before invoking. Templates ensure the model receives a structured, complete prompt rather than an ad-hoc one.

## Failure Budget (§3.5 of AGENTS.md)

Every sub-subtask (`TASKS.md` ID) gets its own `memory/learning/tasks/<id>-attempts.jsonl`; after resolution (success/final failure/workaround) summarize one line to `memory/learning/metrics.jsonl` and delete the per-task file — no unbounded growth. Tool/execution failures stay local (RCA by `review`, workaround, no global `self-help`) unless `review` classifies a recurring structural gap.

## Research Decomposition (§3.9 of AGENTS.md)

When given a vague or broad research prompt, do not attempt to answer in one pass: (1) broad-brush scan to identify major areas and sub-questions, (2) decompose into 3-5 specific targeted sub-questions, (3) invoke researcher for each sub-question with a focused prompt, (4) synthesize findings into the final report.

## Subagent Output Verification (§3.8 of AGENTS.md)

When a subagent returns a report, the planner must verify key claims before using them: (1) mandatory answer to the mission question stated, (2) every factual claim has attached evidence (command/file reference), (3) no empty sections, (4) cross-check with at least two independent sources.

## Verification checklist (before reporting complete)

- [ ] `AGENTS.md` Section 1 filled (Mission); §5 (Learning Loop) and §6 (Skill Policy) intact.
- [ ] §3.5 (Failure Budget), §3.6 (Subagent Templates), §3.7 (Planner vs Execution), §3.8 (Output Verification), §3.9 (Research Decomposition) intact.
- [ ] §7.5-§7.9 intact (Template Management, Self-Help Two-Phase, Reviewer Checklist, Deep Research, Compact Learning Brief).
- [ ] `TASKS.md` reflects actual milestone/task status with sub-subtask IDs (`mN-tN-stN-ssN`).
- [ ] `memory/PROJECT_INDEX.md` verified against repo; paths exist, not invented.
- [ ] `.opencode/skills/` exists with `.gitkeep`; first skill draft placed when loop triggers.
- [ ] `memory/learning/briefs/` + `metrics.jsonl` + `tasks/` present (zero-byte sink ready).
- [ ] `templates/subagent-calls/` contains invocation templates (researcher, review, coder, autopilot).
- [ ] Evidence for any skill creation: source URLs, cross-check ≥2, counterexample, reproduction, Learning Gate checks.


