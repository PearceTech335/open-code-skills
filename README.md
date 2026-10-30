# Open-Code-Skills 🧠🛠️

> *Because even AI coding agents need a little emotional and technical growth.*

A curated collection of production-grade, highly compressed, Power-of-10-inspired agent skills and commands designed to keep your local AI coding assistant disciplined and maintainable.

---

## 🌟 The Crown Jewel: The `self-help` Skill

When an AI agent hits a persistent, systemic knowledge gap, it enters **therapy mode** via the **`self-help`** skill (located in `skills/self-help/`):
1. **Gap Analysis**: Proves the gap is structural (*"Remember: reading a self-help book doesn't fix a broken chair"*).
2. **Sourced Research**: Gathers verified local patterns or official documentation (strictly local — remote URL-based skill injections are disallowed).
3. **Drafts a Structured SKILL.md**: Writes a compact, Power-of-10 compliant skill directly into the skills directory.
4. **Mandatory Human Review**: Pauses, presents its growth to you, and waits for approval before touching production.

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

## 🚀 Quick Start

1. Clone or drop this repository into your OpenCode config directory (`~/.config/opencode/` or project `.opencode/`).
2. Ensure your `opencode.json` wires up instructions and agents.
3. Let your agent practice a little **`self-help`** the next time it encounters a stubborn architectural blind spot!

---

## 🛡️ Security & Supply Chain Safety
- **Local Authorship**: All skills must be authored locally from verified static sources to prevent remote supply chain tampering.
- **WebFetch Guardrails**: WebFetch is restricted by policy to verified documentation only—never for remote agent or config files.

*Fork, adapt, and help your AI learn some manners.* 🤖✨
