# AGENTS_TEMPLATES — Project Starter + Autonomous Learning Loop

This folder is the **copy/paste starter template** for new OpenCode projects. Copypaste its contents (`AGENTS.md`, `TASKS.md`, `memory/`, `.opencode/skills/`) to a new project root. It does **not** replace your global config (`~/.config/opencode/AGENTS.md` + global skills); it layers project-specific rules, the self-improving Learning Loop, and the Skill Policy on top.

## What this folder is for

- **Project-level agent instructions** (`AGENTS.md`) — mission, startup rules, execution protocol, evidence/correctness standards, and the Learning Loop (§5) + Skill Policy (§6).
- **Self-improving skills** (`.opencode/skills/`) — where project-specific skills live; the `self-help` skill drafts them, the Learning Gate validates them, and the Skill Policy controls approval.
- **Project knowledge scaffold** (`memory/`) — persistent index, state, architecture, decisions, known issues, milestones, and the `learning/` sink (`briefs/` + `metrics.jsonl`).
- **Copy/paste starter** — new repo? Drop this folder's contents at root and fill in Section 1 (Mission) and `memory/PROJECT_INDEX.md`.

Global rules (`agent-core`, `readable-code`, `repo-discovery`, `quality-gate`, `security`, WebFetch policy, the global Learning Loop pointer in `AGENTS.md`) still apply. This file gives the project its spin on workflow, knowledge layout, and autonomous improvement.

## How the autonomous Learning Loop works

Wired by `AGENTS.md` §5 and the `reviewer` subagent (`agents/reviewer.md`), with `self-help` (`~/.config/opencode/skills/self-help/SKILL.md`) doing the research/drafting:

```
Task fails on a knowledge-gap failure (second correction attempt fails)
        ↓
reviewer emits LEARNING_BRIEF block
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

**Key rules from `AGENTS.md`:**
- Never generate a skill for a trivial `IMPLEMENTATION_DEFECT`.
- Never weaken original acceptance criteria to make retry pass.
- Auto-approved skills are `Status: auto-approved-provisional`; always audit.
- `max-new-skills-per-run: 3` (cap per autonomous run; exceed → stop/escalate).

## Where agent/skill files live

| Scope | Path | How it's used |
|---|---|---|
| **Global skills** (engineering practices, templates) | `~/.config/opencode/skills/` | Load on demand by agent; include `self-help`, `agent-core`, `readable-code`, `repo-discovery`, `quality-gate`, `long-running-task-research`, `git-practices`, etc. |
| **Project skills** (project-specific patterns, new capabilities) | `.opencode/skills/` (inside this folder / project root) | Drafted by `self-help`; validated by Learning Gate; approved via §6; kept separate from global to avoid pollution |
| **Project agents / subagent specs** | `agents/*.md`, `commands/*.md` | Define roles (`reviewer`, `coder`, etc.) with `description`, `mode`, `prompt`, optional `model:` override (omit to inherit global `model`/`small_model`) |
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

## Verification checklist (before reporting complete)

- [ ] `AGENTS.md` Section 1 filled (Mission); §5 (Learning Loop) and §6 (Skill Policy) intact.
- [ ] `TASKS.md` reflects actual milestone/task status.
- [ ] `memory/PROJECT_INDEX.md` verified against repo; paths exist, not invented.
- [ ] `.opencode/skills/` exists with `.gitkeep`; first skill draft placed when loop triggers.
- [ ] `memory/learning/briefs/` + `metrics.jsonl` present (zero-byte sink ready).
- [ ] `model` / `small_model` in `opencode.json` point at the intended endpoint; no stale `lm-studio/` prefixes; subagent inheritance verified.
- [ ] Evidence for any skill creation: source URLs, cross-check ≥2, counterexample, reproduction, Learning Gate checks.


