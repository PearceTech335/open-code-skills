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
- **`project-index`**: Maintains the standardised `PROJECT_INDEX.md` repository map; load it when project context is missing or stale (pair with `repo-discovery` when exploring before changes).

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
│   ├── architect.md        # software architecture subagent
│   ├── network-engineer.md # OT/network troubleshooting
│   ├── research.md         # discovery/parser subagent
│   ├── review.md           # adversarial review + LEARNING_BRIEF emitter
│   └── test.md             # QA testing — runs test suite, PASS/FAIL with evidence
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
├── templates/AGENTS_TEMPLATES/    # copy/paste starter (AGENTS.md + MISSION.md + TASKS.md + memory/ + .opencode/skills/)
├── templates/subagent-calls/      # invocation templates (researcher, review, test, coder, autopilot)
├── AGENTS.md                     # global agent config (engineering standards, skill hierarchy, verification, Behaviour protocol)
├── opencode.json                  # local-only (gitignored) — endpoint config; agent block removed; model/small_model inheritance
├── .gitignore                     # excludes opencode.json; tracks skills/, agents/, commands/, README.md, templates/
└── README.md
```

Project-level starter (`templates/AGENTS_TEMPLATES/`) layers on top of this global structure and contains its own `MISSION.md` (mission brief, kept separate from `AGENTS.md` §1 so the workflow file can be re-aligned without losing project context), `memory/`, `.opencode/skills/`, and `AGENTS.md` (with Learning Loop section 5 + Skill Policy section 6).

---

## ⚡ Long Horizon Agentic Tasks

This repo wires up the framework for sustained, multi-turn agentic work — from overnight autonomous tasks (`autopilot.md`) through adversarial review (`review.md`) and QA testing (`test.md`) to autonomous skill creation (`self-help`). Each piece is designed to survive beyond a single prompt.

### Subagent Delegation (Updated Behaviour Protocol)
Every agent spec is a `.md` file (`agents/*.md` + `commands/*.md`), not a JSON block. When uncertain: load `agent-core` → invoke structured subagent (`research.md` for ambiguous conditions, `review.md` for verification/failure modes, `test.md` for QA testing of code changes) via completed template; never guess. All subagents inherit the active `model`; planner uses cloud endpoint for planning/classification, local endpoint for execution (protect planner token cap).

Architectural escalation: when a task introduces or exposes significant architectural complexity, the `agent-core` routes to the `architect` sub-agent (`agents/architect.md`) via the Architectural Governance in the global `AGENTS.md` — routine fixes and isolated changes do not invoke it.

### Persistent Memory & Task Lifecycle
Memory is file-first, not context-window-first. Before any multi-turn task, load `memory/PROJECT_INDEX.md`, `memory/CURRENT_STATE.md`, `memory/ARCHITECTURE.md`, and `memory/DECISIONS.md`. `TASKS.md` splits work into milestones; `RESEARCH.md` logs findings with verified/probable/preliminary labels; `PROGRESS.md` writes status. This keeps any single-turn context small — the framework fills what the model sees from persistent files, not from a growing prompt.

### Self-Improving Loop (Autonomous Skill Generation)
When a failure survives a second correction attempt on a **knowledge-gap** root cause (`ALGORITHM_UNDERSTANDING_GAP`, `API_OR_LIBRARY_MISUSE`, `DATA_OR_SCHEMA_CONVENTION_GAP`, etc. — never a trivial `IMPLEMENTATION_DEFECT`), `review.md` emits an `LEARNING_BRIEF` block. From there:

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
Every sub-subtask (`TASKS.md` ID) gets its own `memory/learning/tasks/<id>-attempts.jsonl`; after resolution (success/final failure/workaround) summarize one line to `memory/learning/metrics.jsonl` and delete the per-task file — no unbounded growth. Tool/execution failures (repeated edit mismatches, exact-match errors) stay local (RCA by `review`, workaround, no global `self-help`) unless `review` classifies a recurring structural gap (`ALGORITHM_UNDERSTANDING_GAP`, etc.), which then triggers §5.

### Project-Level Starter
`templates/AGENTS_TEMPLATES/` is the full starter scaffold (not snippets). Copy it into a new project root to implement locally:

```text
<project-root>/
├── AGENTS.md              # §3 execution + §3.5 failure budget (3-strike gate)
├── MISSION.md             # mission brief (separate from AGENTS.md §1; edit when mission changes)
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

The starter implements `AGENTS.md` rules (§3, §3.5, §5, §6) at project level independently of any endpoint or remote sync — apply to the local workspace only.

### Subagent Output Verification
When a subagent returns a report, the planner must verify key claims before using them: (1) mandatory answer to the mission question stated, (2) every factual claim has attached evidence (command/file reference), (3) no empty sections, (4) cross-check with at least two independent sources. Small models produce reports that "have the shape of an answer" but may contain unverified specifics — the planner is the quality gate.

### Subagent Invocation Templates
Standardized prompt templates in `templates/subagent-calls/` (`researcher.md`, `review.md`, `test.md`, `coder.md`, `autopilot.md`). When invoking a subagent, use the corresponding template and fill in the bracketed sections. If no template exists, create one via the self-help process before invoking. Templates ensure the model receives a structured, complete prompt rather than an ad-hoc one.

### Research Decomposition (Vague Prompts)
When given a vague or broad research prompt, do not attempt to answer in one pass: (1) broad-brush scan to identify major areas and sub-questions, (2) decompose into 3-5 specific targeted sub-questions, (3) invoke researcher for each sub-question with a focused prompt, (4) synthesize findings into the final report. This ensures each researcher call is focused and verifiable.

### Planner vs Execution Model Divergence
The planner (top-level `model` in `opencode.json`) runs on the cloud endpoint for planning, root-cause classification, `LEARNING_BRIEF` emission, and approval. Subagent execution (`coder`, `research`, `review`, `test`, `autopilot`) routes through the local endpoint for all writes, reads, edits, tests. This protects the planner's token budget (daily allowance) while keeping execution unbounded (local GPU).

### Endpoint & Model Configuration
`opencode.json` declares endpoint providers generically (`ollama`, `lmstudio-local`, `lmstudio`) and a single `model`; `small_model` removed so all subagents inherit one path — no cross-endpoint routing divergence. The framework is endpoint-agnostic: the same `.md` specs and skills work regardless of which server is active, as long as the declared `model` supports tool calls.

---

## 🛡️ Security & Supply Chain Safety
- **Local Authorship**: All skills must be authored locally from verified static sources to prevent remote supply chain tampering.
- **WebFetch Guardrails**: WebFetch is restricted by policy to verified documentation only—never for remote agent or config files.

*Fork, adapt, and help your AI learn some skills.* 🤖✨
