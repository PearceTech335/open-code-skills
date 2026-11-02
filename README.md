# Open-Code-Skills 🧠🛠️

> *Because even AI coding agents need a little emotional and technical growth.*

A curated collection of production-grade, highly compressed, Power-of-10-inspired agent skills and commands designed to keep your local AI coding assistant disciplined and maintainable.

---

## 🌟 Self-Help Yourself - The `self-help` Skill

When an AI agent hits a persistent, systemic knowledge gap during task execution (such as encountering an unhandled domain framework or complex protocol), you can trigger **therapy mode** via the **`self-help`** skill (located in `skills/self-help/`):

1. **Functional Friction & Discovery**: Instead of sniffing out flaws continuously, the agent discovers a gap when hitting repeated roadblocks where existing Power-of-10 skills (`python-code`, `designer`, etc.) fall short, or when invoked directly via `/improve`.
2. **Strict Gap Analysis**: It proves the gap is structural and recurring (*"Remember: reading a self-help book doesn't fix a broken chair"* — one-off difficult bugs do not qualify).
3. **Sourced Research**: It gathers verified local patterns or official documentation (strictly local & verified sources only — remote URL-based skill injections are forbidden to prevent supply chain rug-pulls).
4. **Drafts & Places SKILL.md**: It writes a compact, Power-of-10 compliant skill directly into `skills/<skill-name>/SKILL.md` and registers it in `AGENTS.md`.
5. **Mandatory Human Review Gate**: It pauses execution, presents its newly drafted skill to you, and waits for explicit approval before activation.

---

## 📂 What’s Inside?

### 🧠 Core & Meta Skills
- **`agent-core`**: Tool call discipline, four-phase protocol (Explore, Plan, Execute, Verify), and course-correction rules.
- **`self-help`**: Autonomous skill generation for systemic gaps with strict safety guardrails.
- **`auto-memory`**: Session learning journal to persist non-obvious insights across sessions without RAG.
- **`template-library`**: Reusable code patterns and snippet management.

### 🏗️ Design & Quality Skills
- **`readable-code`**: Cross-language coding standards for human-maintainable code (intent-obvious naming, simple solutions, robust error handling).
- **`designer`**: Enforces solid project design methods (Single Responsibility, Separation of Concerns, Dependency Direction, Minimal Abstraction).
- **`quality-gate`**: Final multi-dimensional review checklist (correctness, readability, architecture, security, performance).
- **`repo-discovery`**: Architecture exploration before changing code (entry points, dependency mapping, call-chain tracing).

### 💻 Language & Domain Skills
- **`python-code`**, **`go-code`**, **`typescript-code`**: Production coding standards inspired by the NASA/JPL Power of 10 rules (short functions, strict type hints, path operations via `pathlib`, specific exception handling).
- **`bash-skill`**, **`powershell-skill`**, **`ansible-code`**: Robust, idempotent automation guardrails for sysadmins and OT engineers.
- **`security`**, **`penetration-tester`**, **`networking`**, **`ot-networking`**, **`packet-analysis`**: Evidence-first domain investigation and security review standards.

### ⚡ Custom Commands (`commands/`)
- **`/overnight`**: Turns any prompt into a `TASKS.md` checklist and runs an unattended autonomous worker.
- **`/research`**: Fast file parsing and information extraction via specialized subagents.
- **`/improve`**: Triggers the `self-help` skill workflow to research and draft new skills.
- **`/review` & `/investigate`**: Evidence-first code and network troubleshooting commands.

---

## 🚀 Quick Start & File Placement

Drop these files directly into your OpenCode global configuration directory (`~/.config/opencode/` on Linux/macOS/Windows) or a project-level `.opencode/` folder. 

Your directory structure should include:

```text
~/.config/opencode/
├── agents/
│   ├── autopilot.md        # overnight autonomous worker
│   ├── coder.md            # code generation subagent
│   ├── network-engineer.md # OT/network troubleshooting
│   ├── research.md         # discovery/parser subagent
│   └── reviewer.md         # adversarial review + LEARNING_BRIEF emitter
├── commands/
│   ├── improve.md
│   ├── investigate.md
│   ├── overnight.md
│   ├── research.md
│   └── review.md
├── skills/
│   ├── agent-core/SKILL.md
│   ├── self-help/SKILL.md         # autonomous skill generation + brief templates
│   ├── agent-core/SKILL.md
│   ├── readable-code/SKILL.md
│   └── ... (full skill library)
├── skills/self-help/templates/
│   ├── learning-brief.md
│   └── skill-template.md
├── templates/AGENTS_TEMPLATES/    # copy/paste starter (AGENTS.md + TASKS.md + memory/ + .opencode/skills/)
├── opencode.json                  # endpoint config (3 providers); agent block removed; model/small_model inheritance
├── .gitignore                     # excludes everything except skills/, agents/, commands/, README.md, templates/
└── README.md
```

Project-level starter (`templates/AGENTS_TEMPLATES/`) layers on top of this global structure and contains its own `memory/`, `.opencode/skills/`, and `AGENTS.md` (with Learning Loop section 5 + Skill Policy section 6).

---

## 🔄 Autonomous Learning Loop (Self-Improving Skills)

This repo wires up the **Review-Triggered Learning Brief → Self-Help → Skill → Retry → Metrics** loop defined in `AGENTS.md` (§5, Learning Loop) and `skills/self-help/SKILL.md`.

**How it activates:** When the `reviewer` subagent (`agents/reviewer.md`) survives a second correction attempt on a knowledge-gap failure, it emits a `LEARNING_BRIEF` block.

**Path:**
```
1. reviewer → LEARNING_BRIEF block
2. Write brief → memory/learning/briefs/<task-id>.md  (template: skills/self-help/templates/learning-brief.md)
3. Load self-help skill → pass Brief path
4. self-help researches (≥2 sources, cross-check, critique, counterexample, repro)
5. Drafts Power-of-10 skill → .opencode/skills/<new-skill>/SKILL.md  (template: skills/self-help/templates/skill-template.md)
6. Learning Gate (5 checks: evidence, relevance, correctness, scope, executable check)
7. Approval via AGENTS.md §6 Skill Policy:
     auto-approve: project-skills  → activates as auto-approved-provisional
     (line removed / off)          → pauses for human review
8. Retry against ORIGINAL criteria (not weakened) + FULL regression suite
9. Append JSON line → memory/learning/metrics.jsonl
```

**Agent / skill file placement:**
- Project-specific skills → `.opencode/skills/` (inside your project root)
- Global skills → `~/.config/opencode/skills/` (this repo's contents)
- Agent specs (reviewer, coder, etc.) → `agents/*.md` + `commands/*.md`
- Project starter / template → `templates/AGENTS_TEMPLATES/` (copy/paste to new project root; layers on global `AGENTS.md`)

**Key guardrails from `AGENTS.md`:**
- Never generate for trivial `IMPLEMENTATION_DEFECT`
- Never weaken acceptance criteria for retry
- Auto-approved skills are provisional — audit in `.opencode/skills/` + `metrics.jsonl`
- Cap: `max-new-skills-per-run: 3`; exceed → stop/escalate

---

## 🛡️ Security & Supply Chain Safety
- **Local Authorship**: All skills must be authored locally from verified static sources to prevent remote supply chain tampering.
- **WebFetch Guardrails**: WebFetch is restricted by policy to verified documentation only—never for remote agent or config files.

*Fork, adapt, and help your AI learn some skills.* 🤖✨
