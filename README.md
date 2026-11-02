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

## ⚡ Long Horizon Agentic Tasks

This repo wires up the framework for sustained, multi-turn agentic work — from overnight autonomous tasks (`autopilot.md`) through adversarial review (`reviewer.md`) to autonomous skill creation (`self-help`). Each piece is designed to survive beyond a single prompt.

### Subagent Delegation
Every agent is a `.md` spec (`agents/*.md` + `commands/*.md`), not a JSON block. Loading is explicit: load `agent-core` first (Skill Inventory Protocol), then invoke `coder` / `research` / `reviewer` / `autopilot` via the planner or `--agent` flag. All inherit the active `model`; no per-agent provider divergence (`small_model` removed from `opencode.json`).

### Persistent Memory & Task Lifecycle
Memory is file-first, not context-window-first. Before any multi-turn task, load `memory/PROJECT_INDEX.md`, `memory/CURRENT_STATE.md`, `memory/ARCHITECTURE.md`, and `memory/DECISIONS.md`. `TASKS.md` splits work into milestones; `RESEARCH.md` logs findings with verified/probable/preliminary labels; `PROGRESS.md` writes nightly status. This keeps any single-turn context small — the framework fills what the model sees from persistent files, not from a growing prompt.

### Self-Improving Loop (Autonomous Skill Generation)
When a failure survives a second correction attempt on a **knowledge-gap** root cause (`ALGORITHM_UNDERSTANDING_GAP`, `API_OR_LIBRARY_MISUSE`, `DATA_OR_SCHEMA_CONVENTION_GAP`, etc. — never a trivial `IMPLEMENTATION_DEFECT`), `reviewer.md` emits an `LEARNING_BRIEF` block. From there:

```
1. Planner writes brief → memory/learning/briefs/<task-id>.md
2. Load self-help skill (skills/self-help/SKILL.md) → pass Brief path
3. Self-help researches (≥2 verified sources + adversarial counterexample + reproducible test)
4. Drafts compact Power-of-10 skill → .opencode/skills/<new-skill>/SKILL.md
5. Learning Gate: evidence, relevance, correctness, scope, executable check
6. Approval: AGENTS.md §6 Skill Policy — auto-approve: project-skills activates as provisional; off pauses for human review
7. Retry against ORIGINAL criteria (never weakened) + FULL regression suite
8. Append JSON line → memory/learning/metrics.jsonl
```
Auto-approved skills are provisional — audit `.opencode/skills/` and `metrics.jsonl`. Cap: `max-new-skills-per-run: 3`; exceed → stop/escalate.

### Skill Policy & Lightweight Design
`AGENTS.md` §6 declares `auto-approve: project-skills` and the cap above; set policy to `off` for full human gate. Skills live in `skills/` (global) and `.opencode/skills/` (project); agent specs live in `agents/*.md` + `commands/*.md`. `templates/AGENTS_TEMPLATES/` is the copy/paste starter (includes `AGENTS.md`, `TASKS.md`, `memory/`, `.opencode/skills/`). No JSON `agent` block — managing agents is add/remove one `.md` file.

### Failure Budget (3-Strike Gate)
Every sub-subtask (`TASKS.md` ID) gets its own `memory/learning/tasks/<id>-attempts.jsonl`; after resolution (success/final failure/workaround) summarize one line to `memory/learning/metrics.jsonl` and delete the per-task file — no unbounded growth.

### Project-Level Starter & GitHub Sync
`templates/AGENTS_TEMPLATES/` is the full starter scaffold (not just snippets). Copy it into a new project root and commit to that project's repo:

```text
<project-root>/
├── AGENTS.md              # §3 execution + §3.5 failure budget (3-strike gate)
├── TASKS.md               # milestone / sub-subtask IDs (mN-tN-stN-ssN)
├── memory/
│   ├── CURRENT_STATE.md   # active milestone + open sub-subtasks
│   ├── PROJECT_INDEX.md   # repo navigation
│   ├── learning/tasks/    # per-sub-subtask attempt files (created, then purged)
│   ├── learning/metrics.jsonl  # summary line after resolution
│   └── ...
├── .opencode/
│   └── skills/            # project-scoped skills (optional)
└── README.md              # copies the Long Horizon section
```

How it syncs: the starter layers on global `~/.config/opencode/` (skills, agents, `opencode.json`). Project `AGENTS.md` can declare `auto-approve: project-skills` (§6) and the failure-budget rules (§3.5) independently of any machine — the same rules run whether the endpoint is local or remote. Push the starter folder to the project repo so collaborators inherit the same task-breakdown format, retry-counter rotation rule (`memory/learning/tasks/<id>-attempts.jsonl` → `metrics.jsonl` → delete), and `reviewer`-emission workflow without recreating it.

### Endpoint & Model Configuration
`opencode.json` declares endpoint providers generically (`ollama`, `lmstudio-local`, `lmstudio`) and a single `model`; `small_model` removed so all subagents inherit one path — no cross-endpoint routing divergence. The framework is endpoint-agnostic: the same `.md` specs and skills work regardless of which server is active, as long as the declared `model` supports tool calls.

---

## 🛡️ Security & Supply Chain Safety
- **Local Authorship**: All skills must be authored locally from verified static sources to prevent remote supply chain tampering.
- **WebFetch Guardrails**: WebFetch is restricted by policy to verified documentation only—never for remote agent or config files.

*Fork, adapt, and help your AI learn some skills.* 🤖✨
